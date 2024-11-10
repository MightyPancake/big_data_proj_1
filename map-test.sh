hadoop fs -rm -r output

mapred streaming \
    -files mapper.py,reducer.py,combiner.py \
    -input input \
    -output output \
    -mapper "python3 mapper.py" \
    -combiner "python3 combiner.py" \
    -reducer "python3 reducer.py" \

