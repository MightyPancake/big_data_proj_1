hadoop fs -rm -r output

mapred streaming \
    -files mapper.py,reducer.py,combiner.py \
    -input input/datasource1/part-00000 \
    -output output \
    -mapper "python3 mapper.py" \
    -combiner "python3 combiner.py" \
    -reducer "python3 reducer.py" \
    -jobconf mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -jobconf stream.num.map.output.key.fields=2 \
    -jobconf mapreduce.partition.keycomparator.options="-k1,1 -k2,2" \
    -jobconf mapreduce.map.output.key.field.separator=\t

