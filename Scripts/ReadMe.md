# Hadoop on MRI

## Install
wget http://psg.mtu.edu/pub/apache/hadoop/common/hadoop-2.7.0/hadoop-2.7.0.tar.gz
tar -xzf hadoop-2.7.0.tar.gz

## Forward
slogin -L 50070:c11u21:50070 -L 8088:c11u21:8088 mri1.rnet.missouri.edu

## Allocate Nodes
srun -p GPU -N 10 ./dfs.sh
srun -p GPU -N 10 ./yarn.sh

## Test
. env.sh
hadoop fs -mkdir /test1               
hadoop fs -copyFromLocal env.sh /test1
hadoop fs -cat /test1/env.sh   

## Clean
srun -N27 rm -rf /tmp/hadoop-${USER} /local/scratch/${USER}/hadoop 

## MS App

git clone git@github.com:nguyen14ck/neuro_classifier
git clone git@github.com:nguyen14ck/neuro_mre

## Classifier
. env.sh
hadoop fs -mkdir /input
hadoop fs -mkdir /output
hadoop fs -mkdir /output/cloth_output_sample
hadoop fs -copyFromLocal cloth_train_sample1.txt /input
hadoop fs -copyFromLocal cloth_train_sample2.txt /input
hadoop fs -copyFromLocal cloth_test_sample.txt /input

yarn jar senti_classify.jar neuro.mre.senti_classify 2 /input/cloth_train_sample1.txt /input/cloth_train_sample2.txt /input/cloth_test_sample.txt /output/cloth_output_sample

rm -rf cloth_output_sample
hadoop fs -copyToLocal /output/cloth_output_sample .

## MRE
hadoop fs -mkdir /input
hadoop fs -mkdir /output
hadoop fs -mkdir /output/ling_output_sample
hadoop fs -copyFromLocal sample_reviews.txt /input

yarn jar ling2.jar neuro.mre.ling2 /input/sample_reviews.txt /output/ling_output_sample

rm -rf ling_output_sample
hadoop fs -copyToLocal /output/ling_output_sample .
