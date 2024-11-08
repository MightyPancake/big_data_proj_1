#!/bin/bash

# Usuń istniejący folder output (jeśli istnieje)
hadoop fs -rm -r output

# Uruchom zadanie map-reduce z hadoop-streaming
mapred streaming \
    -files mapper.py,reducer.py,combiner.py \
    -input input/datasource1 \
    -output output \
    -mapper mapper.py \
    -combiner combiner.py \
    -reducer python3 reducer.py \
    -jobconf mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
    -jobconf stream.num.map.output.key.fields=2 \
    -jobconf mapreduce.partition.keycomparator.options="-k1,1 -k2,2"
