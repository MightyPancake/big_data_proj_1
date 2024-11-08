hadoop fs -rm -r output

mapred streaming \
    -files mapper.py,reducer.py,combiner.py \
    -input input/datasource1 \
    -output output \
    -mapper "python3 mapper.py" \
    -combiner "python3 combiner.py" \
    -reducer "python3 reducer.py" \
    -D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -D stream.num.map.output.key.fields=2 \
    -D mapreduce.partition.keycomparator.options="-k1,1 -k2,2"

# Last 3 switches make it so I don't have to merge 2 keys into one (which would be extremely dumb, but is likely what people do lol)

# Ignore this, it was just a local test
# cat input/datasource1/* | python mapper.py | sort -k1,1 | python reducer.py > output
