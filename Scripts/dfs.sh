#!/bin/bash
# Hadoop on SLURM by Timothy Middlekoop

## Node configuration
node0='c11u21'

## Performance configuration
export HADOOP_HEAPSIZE=65000

## Version onfiguration
version=2.7.0
export JAVA_HOME=/usr/lib/jvm/java-1.7.0

## local variables
data="/local/scratch/${USER}/hadoop"
bin="./hadoop-${version}/bin"
etc="./hadoop-${version}/etc/hadoop"
hostname="$(hostname -s)"
hdfs="hdfs://${node0}:9000/"

## Setup
echo +++ dfs.sh $hostname

rm -rf ${data}
rm -rf /tmp/hadoop-${USER}
install -dv ${data}
ln -sf ${data} /tmp/hadoop-${USER}

if [ ${hostname} == ${node0} ] ; then
  ## Headnode
  echo NAME $hostname
  cat > ${etc}/core-site.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>${hdfs}</value>
    </property>
</configuration>
EOF
  ${bin}/hdfs namenode -format -force
  ${bin}/hdfs namenode
else
  ## Data node
  echo DATA $hostname
  ${bin}/hdfs datanode -fs ${hdfs}
fi
