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

LOAD DATA INPATH '/user/muushroom_pl/output' INTO TABLE datasource3;

CREATE TABLE datasource4 (
    street STRING,
    person_type STRING,
    killed INT,
    injured INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

LOAD DATA INPATH '/user/muushroom_pl/input/datasource4' INTO TABLE datasource4;
