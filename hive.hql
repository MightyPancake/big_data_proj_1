-- Drop existing tables
DROP TABLE IF EXISTS datasource3;
DROP TABLE IF EXISTS datasource4;

-- Create and load datasource3
CREATE TABLE datasource3 (
    street STRING,
    person_type STRING,
    killed INT,
    injured INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

LOAD DATA INPATH '${input_dir3}' INTO TABLE datasource3;

-- Create and load datasource4
CREATE TABLE datasource4 (
    zip_code STRING,
    borough STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '${input_dir4}' INTO TABLE datasource4;

-- Join datasource3 with datasource4 to get only records from Manhattan
DROP TABLE IF EXISTS manhattan_data;

CREATE TABLE manhattan_data AS
SELECT
    ds3.street,
    ds3.person_type,
    ds3.killed,
    ds3.injured
FROM
    datasource3 ds3
JOIN
    datasource4 ds4
ON
    ds3.zip_code = ds4.zip_code
WHERE
    ds4.borough = 'MANHATTAN';

-- Summing killed and injured for each street and person type in Manhattan
DROP TABLE IF EXISTS summed_injured_killed;

CREATE TABLE summed_injured_killed AS
SELECT
    street,
    person_type,
    SUM(killed) AS total_killed,
    SUM(injured) AS total_injured
FROM manhattan_data
GROUP BY street, person_type;

-- Insert the top 3 streets with the highest injured+killed count for each person_type
INSERT OVERWRITE DIRECTORY '${output_dir6}'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.JsonSerDe'
SELECT
    street,
    person_type,
    total_killed,
    total_injured
FROM (
    SELECT
        street,
        person_type,
        total_killed,
        total_injured,
        ROW_NUMBER() OVER (PARTITION BY person_type ORDER BY (total_killed + total_injured) DESC) AS row_num
    FROM summed_injured_killed
) ranked
WHERE row_num <= 3
ORDER BY person_type, row_num;

