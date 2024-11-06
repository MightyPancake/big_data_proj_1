-- Usunięcie tabeli, jeśli już istnieje
DROP TABLE IF EXISTS datasource4;

-- Tworzenie nowej tabeli w Hive
CREATE TABLE datasource4 (
    street STRING,
    person_type STRING,
    killed INT,
    injured INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- Załadowanie danych z HDFS do nowo utworzonej tabeli
LOAD DATA INPATH '/user/muushroom_pl/output' INTO TABLE datasource4;
