-- Drop existing tables
DROP TABLE IF EXISTS datasource3;
DROP TABLE IF EXISTS datasource4;

-- Create and load datasource3
CREATE TABLE datasource3 (
    street STRING,
    zip_code STRING,
    victim_type STRING,
    injury_type STRING,  -- Zmieniono na STRING, aby odzwierciedlić rodzaj obrażenia (np. "killed" lub "injured")
    count INT
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

-- Wyselekcjonowanie danych tylko dla Manhattanu
DROP TABLE IF EXISTS manhattan_data;

CREATE TABLE manhattan_data AS
SELECT
    ds3.street,
    ds3.victim_type AS person_type,
    ds3.injury_type,
    ds3.count
FROM
    datasource3 ds3
JOIN
    datasource4 ds4
ON
    ds3.zip_code = ds4.zip_code
WHERE
    ds4.borough = 'MANHATTAN';

-- Sumowanie liczby rannych i zabitych dla każdej ulicy i typu poszkodowanych
DROP TABLE IF EXISTS summed_injured_killed;

CREATE TABLE summed_injured_killed AS
SELECT
    street,
    person_type,
    SUM(CASE WHEN injury_type = 'killed' THEN count ELSE 0 END) AS total_killed,
    SUM(CASE WHEN injury_type = 'injured' THEN count ELSE 0 END) AS total_injured
FROM manhattan_data
GROUP BY street, person_type;

-- Wyselekcjonowanie trzech ulic o najwyższej liczbie poszkodowanych dla każdego typu poszkodowanego
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
