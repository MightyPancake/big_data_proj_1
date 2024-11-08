hadoop fs -rm -r output
mapred streaming -files mapper.py,reducer.py -input input/datasource1 -output output -mapper "python3 mapper.py" -reducer "python3 reducer.py"

# Ignore this, it was just a local test
# cat input/datasource1/* | python mapper.py | sort -k1,1 | python reducer.py > output
