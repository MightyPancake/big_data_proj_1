DROP TABLE IF EXISTS datasource3;
DROP TABLE IF EXISTS datasource4;

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

CREATE TABLE datasource4 (
    street STRING,
    person_type STRING,
    killed INT,
    injured INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

LOAD DATA INPATH '${input_dir4}' INTO TABLE datasource4;

INSERT OVERWRITE DIRECTORY '/user/your_hive_user/output/json_results'
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
