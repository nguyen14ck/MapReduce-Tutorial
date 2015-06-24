# MapReduce-Tutorial

This tutorial bases on Dr. Middelkoop’s scripts to introduce how to run MapReduce job on MRI system of University of Missouri, Columbia. The system is a high-performance computational infrastructure for inter-campus research collaboration.


# Cluster configuration
This Hadoop cluster includes 10 nodes:
	10 * 128 Gb (72 vcores), Dell R730 with  2 x E5-2660v3 (2.6Ghz 10-Core), CentOS 5

First, you use Putty to connect to Linux Server, and logon with your mri account.
 
 ![image001](https://cloud.githubusercontent.com/assets/6707375/8341079/4790d988-1a88-11e5-95a8-fad5ab51a692.png)
 
 ![image003](https://cloud.githubusercontent.com/assets/6707375/8341114/8c823726-1a88-11e5-8f44-e21e72bb47ad.png)

After you log on, you change directory to Hadoop folder and list its content.

```Shell
$ cd Hadoop
$ ls
```
![image005](https://cloud.githubusercontent.com/assets/6707375/8341115/8c82de88-1a88-11e5-8810-93737f6ffc55.png)

There are three necessary files to initialize Hadoop cluster:

	env.sh: contains environmental variables
	dfs.sh: contains configuration of name node (to store data on Hadoop file system)
	yarn.sh: contains configuration of computational node (YARN is MapReduce 2.0)
	
Support file:

	Readme.md: includes scripts to execute tasks

Instead of changing directly Hadoop cluster’s configuration, we use these file to set configuration parameters each time we initialize the system.

env.sh setup path to JAVA HOME, HADOOP HOME
And HEAPSIZE memory for HADOOP. This number must be consistent with values of HEAPSIZE in file dfs.sh and yarn.sh

![image007](https://cloud.githubusercontent.com/assets/6707375/8341119/8cba3c20-1a88-11e5-8594-d15f439425d6.png)
 
dfs.sh configures how to run data node for Hadoop cluster
The HEAPSIZE here equals previous value in env.sh.

dfs.sh also configures block size of Hadoop file system (default value is 128mb). This size will decide how many parts each input file will be split to handle in parallel.
 
 ![image008](https://cloud.githubusercontent.com/assets/6707375/8341120/8cbcbdb0-1a88-11e5-8f27-0730cab83988.png)


yarn.sh set up configuration for computational node.
```
	HEAPSIZE: 65000 mb (larger 1000 mb for safety)
		|____ Node manager memory: 64000 mb
	                        |____ Container’s memory: from 8000 mb to 16000 mb (must be larger than Map + Reduce)
	                                        |____ Map: 7000 mb
	                                              	        |____ Java virtual machine memory (opts): 3000 mb
	                                                        |____ Memory for computational data: 4000 mb
	                                        |____ Reduce: 9000 mb
	                                                        |____ Java virtual machine memory (opts): 3000 mb
	                                                        |____ Memory for computational data: 6000 mb 

 ```
 
![image009](https://cloud.githubusercontent.com/assets/6707375/8341118/8cb694da-1a88-11e5-9c5e-cff7a5a78aee.png)
 
![image011](https://cloud.githubusercontent.com/assets/6707375/8341116/8c9eee66-1a88-11e5-903a-d93d548d6d9a.png)

![image012](https://cloud.githubusercontent.com/assets/6707375/8341117/8c9f38c6-1a88-11e5-80e1-a1dcb0ed642d.png)

 
# Turn on cluster
 
Open Readme.md file to view instruction and nitialize name node

![image013](https://cloud.githubusercontent.com/assets/6707375/8341122/8cc16e82-1a88-11e5-8a4a-1ba9f998bbb0.png)

```Shell
$ cat Readme.md
$ . env.sh
$ srun -p GPU -N 10 ./dfs.sh
```

Now open another Putty window for computational node

![image015](https://cloud.githubusercontent.com/assets/6707375/8341123/8cc1c666-1a88-11e5-815c-c5ef343d1055.png)

```Shell
$ cat Readme.md
$ . env.sh
$ srun -p GPU -N 10 ./yarn.sh
```
 

And open the third Putty window for proxy to monitor Hadoop Jobs

![image016](https://cloud.githubusercontent.com/assets/6707375/8341124/8cd5355c-1a88-11e5-89c3-685fda13a6fb.png)
 

# Prepare data and run MapReduce job

```Shell
$ hadoop fs -mkdir /input
$ hadoop fs -mkdir /output
$ hadoop fs -mkdir /output/cloth_output_sample

$ hadoop fs -copyFromLocal cloth_train_sample1.txt /input
$ hadoop fs -copyFromLocal cloth_train_sample2.txt /input
$ hadoop fs -copyFromLocal cloth_test_sample.txt /input

$ yarn jar senti_classify.jar neuro.mre.senti_classify 2 /input/cloth_train_sample1.txt /input/cloth_train_sample2.txt /input/cloth_test_sample.txt /output/cloth_output_sample
```

# Monitor MapReduce job and result

![image018](https://cloud.githubusercontent.com/assets/6707375/8341125/8cd6d010-1a88-11e5-863a-041295fecec9.png)

![image020](https://cloud.githubusercontent.com/assets/6707375/8341126/8cd823ca-1a88-11e5-9ce7-7fd827bbc3e7.png)

![image022](https://cloud.githubusercontent.com/assets/6707375/8341127/8cdcc5a6-1a88-11e5-8333-d5cb73600cd1.png)

 

 
