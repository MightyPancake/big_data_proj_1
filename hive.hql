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
    street STRING,
    person_type STRING,
    killed INT,
    injured INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA INPATH '${input_dir4}' INTO TABLE datasource4;

-- Create summed_injured_killed table
DROP TABLE IF EXISTS summed_injured_killed;

CREATE TABLE summed_injured_killed AS
SELECT
    street,
    person_type,
    SUM(killed) AS total_killed,
    SUM(injured) AS total_injured
FROM (
    SELECT street, person_type, killed, injured FROM datasource3
    UNION ALL
    SELECT street, person_type, killed, injured FROM datasource4
) combined
GROUP BY street, person_type;

-- This crates output dir if it doesn't exist
!hadoop fs -test -d ${output_dir6} || hadoop fs -mkdir -p ${output_dir6}

INSERT OVERWRITE DIRECTORY '${output_dir6}'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS JSON
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
