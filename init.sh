wget http://www.cs.put.poznan.pl/kjankiewicz/bigdata/projekty/zestaw3.zip
unzip zestaw3
rm zestaw3.zip
hadoop fs -mkdir -p input
hadoop fs -put ./input/* input

