# Cassandra.ClusterSplitDockerTestEnv
A Docker test environment to simulate breaking one Cassandra cluster into two clusters. The "current/old" cluster exists out of 3 DC's (datacenterone, datacentertwo, datacenterthree) with 7 nodes each. The "new" cluster is a clone of this setup. The goal of this setup is to prove the concept of splitting one large cluster into two smaller clusters. However you can also use the first script as a standalone to spin up just the first cluster to test out your own Cassandra scripts.

# My test setup
This setup was tested on an Azure VM (Standard E64s v3 (64 vcpus, 432 GiB memory) with Linux (ubuntu 18.04) with a datatable with about 10GB's of data.

# How to use
Install Docker on an Azure Linux Ubuntu 18.04 VM. After this its simply running the scripts in order (they are numbered).

# Description of the files.
There is a set of Linux scripts which you can run on the docker host. During running these files the Cassandra yamls get updated. For example the clustername, ip's & seeds will be set at the appropriate times. Here a list of the scripts with their functions:

## 1.bootcurrent.sh
- Cleans up any leftovers of a previous run
- Creates 2 docker networks for a simulation of a real world scenario
- Setup a Cassandra cluster with 3 DC's with 7 nodes each (so 21 nodes in total).

## 2.loaddata.sh
The following keyspace, table & data CSV files were created using my [Cassandra.BackupAndRestore](https://github.com/RobHofmann/Cassandra.BackupAndRestore) tool.
 - Replicate some Cassandra keyspaces over the datacenters (some system_ tables) required to let the cluster function
 - Creates a keyspace (dummykeyspace) & table (dummytable) from their respective definition files.
 - Load data from a CSV

## 3.bootnew.sh
 - Open the connection between the two networks
 - Add 3 more DC's with 7 nodes each (so you get 42 nodes in total)

## 4.distributedata.sh
 - Replicate some Cassandra keyspaces over the datacenters (some system_ tables) required to let the cluster function
 - Distribute our dummykeyspace over 6 datacenters

## 5.rebuildnewdcs.sh
 - Do a rebuild on all new nodes to make sure the data is present on all nodes

## 6.selects.sh
 - Prints some output from selectstatements to see where our data is present.

## 7.moveawayfromoldcluster.sh
 - Set keyspace replication to only the new cluster (so it will be removed from the old/current cluster)
 - Check how big the keyspace datafolder on disk is for one of the old/current cluster nodes
 - Do a nodetool cleanup to cleanup the data from the old/current cluster
 - Check again how bit the keyspace datafolder on disk is for one of the old/current cluster nodes (this should be 0 or nearly 0 now)

## 8.disconnectclusters.sh
 - Close the connection between the docker networks using IP tables (so put the firewall up again).

## 9.postsplit.sh
 - Make sure the 2 (now splitted) clusters replicate some Cassandra keyspaces over the correct datacenters (some system_ tables) required to let the cluster function

## 10.selects.sh
 - Prints some output from selectstatements to see where our data is present.

## 11.removedeadnodes.sh
 - After splitting the cluster in two, this script will remove all unreachable nodes from the clusters (old nodes get removed on the new cluster and vise versa)

## 12.dropkeyspaceonold.sh
 - Drop our dummykeyspace on the old cluster (this should give an error on the console)

## 13.replaceclusternameonnew.sh
 - Rename the new cluster with a new name (if you don't do this and the clusters will connect in the future (on purpose or by accident), all clusters & nodes will go mental and your cluster will pretty much explode. All nodes will be on their own not able to talk to eachother anymore)

## 14.restartcluster.sh
 - Restart all nodes to make sure everything still works.

## 15.openiptables.sh
 - Open the networks to eachother again to prove our steps from script 13.replaceclusternameonnew.sh have worked and do what we expect.

# Disclaimer
I am in NO WAY responsible for any dataloss for using this process on any of your environments. Also I am NOT an expert on Cassandra, i just fiddle around until something works :).