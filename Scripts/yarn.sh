#!/bin/bash
# Hadoop on SLURM by Timothy Middlekoop

## Node configuration
node0='c11u21'

## Performance configuration
#export HADOOP_HEAPSIZE=65000

## Version onfiguration
version=2.7.0
export JAVA_HOME=/usr/lib/jvm/java-1.7.0

## local variables
data="/local/scratch/${USER}/hadoop"
bin="./hadoop-${version}/bin"
etc="./hadoop-${version}/etc/hadoop"
hostname="$(hostname -s)"
hdfs="hdfs://${node0}:9000/" 
yarn="${node0}"

## Setup
echo +++ yarn.sh $hostname

if [ ${hostname} == ${node0} ] ; then
  ## Headnode
  echo RESOURCE $hostname
  cat > ${etc}/yarn-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>${yarn}</value>
    </property>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>64000</value>
  </property>
  <property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>8000</value>
  </property>
  <property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>16000</value>
  </property>
</configuration>
EOF
  cat > ${etc}/mapred-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>mapreduce.map.memory.mb</name>
    <value>7000</value>
  </property>
  <property>
    <name>mapreduce.reduce.memory.mb</name>
    <value>9000</value>
  </property>
  <property>
    <name>mapreduce.map.java.opts</name>
    <value>-Xmx3000m</value>
  </property>
  <property>
    <name>mapreduce.reduce.java.opts</name>
    <value>-Xmx4000m</value>
  </property>

</configuration>
EOF
  ${bin}/yarn resourcemanager
else
  ## Data node
  echo NODE $hostname
  ${bin}/yarn nodemanager
fi
