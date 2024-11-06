wget http://www.cs.put.poznan.pl/kjankiewicz/bigdata/projekty/zestaw3.zip
unzip zestaw3
rm zestaw3.zip
hadoop fs -mkdir -p input
hadoop fs -put ./input/* input

wget https://raw.githubusercontent.com/MightyPancake/big_data_proj_1/refs/heads/main/mapper.py
wget https://raw.githubusercontent.com/MightyPancake/big_data_proj_1/refs/heads/main/reducer.py
sudo chmod +x mapper.py
sudo chmod +x reducer.py

hadoop fs -rm -r output
mapred streaming -files mapper.py,reducer.py -input input/datasource1 -output output -mapper "python3 mapper.py" -reducer "python3 reducer.py"

# cat input/datasource1/* | python mapper.py | sort -k1,1 | python reducer.py > output
