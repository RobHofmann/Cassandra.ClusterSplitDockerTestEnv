#!/bin/bash

function SetOldDCSeeds {
    for filename in \
        `ls cassandrayaml | grep "cassandra_dcone" | grep -v 9` \
        `ls cassandrayaml | grep "cassandra_dctwo" | grep -v 9` \
        `ls cassandrayaml | grep "cassandra_dcthree" | grep -v 9` \
    ; do
        sed -i -r 's/(- seeds:).*/\1 "'"$1"'"/' cassandrayaml/$filename
    done
}

function SetNewDCSeeds {
    for filename in \
        `ls cassandrayaml | grep "cassandra_dcone9"` \
        `ls cassandrayaml | grep "cassandra_dctwo9"` \
        `ls cassandrayaml | grep "cassandra_dcthree9"` \
    ; do
        sed -i -r 's/(- seeds:).*/\1 "'"$1"'"/' cassandrayaml/$filename
    done
}

function SetNewClusterName {
    for filename in \
        `ls cassandrayaml | grep "cassandra_dcone9"` \
        `ls cassandrayaml | grep "cassandra_dctwo9"` \
        `ls cassandrayaml | grep "cassandra_dcthree9"` \
    ; do
        sed -i -r 's/^(# )?('"cluster_name"':).*/\2 '"$1"'/' cassandrayaml/$filename
    done
}

function UpdateClusternameInMemoryForNewCluster {
    for containername in \
        `docker ps --format "{{.Names}}" | grep dcone9` \
        `docker ps --format "{{.Names}}" | grep dctwo9` \
        `docker ps --format "{{.Names}}" | grep dcthree9` \
    ; do
        echo "Updating node $containername"
        docker exec -i $containername cqlsh -e "update system.local set cluster_name='$1' where key='local';"
        docker exec -i $containername nodetool flush
    done
}

echo "Get container ip's"
# Set IP's (var names will be $dcone1_ip $dctwo1_ip etc). Only for the "current" part of the cluster.
containers=$(docker ps --format "{{.Names}}")
for container in $containers
do
    ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
    tmpIpVarName="$container""_ip"
    eval $tmpIpVarName=\"$ip\"
done
echo "Done getting container ip's"

echo "Updating new cluster with new seeds & clustername"
SetNewClusterName "New_Test_Cluster"
SetNewDCSeeds "$dcone91_ip,$dctwo91_ip,$dcthree91_ip"
echo "Done updating new cluster with new seeds & clustername"

echo "Updating tables with new clustername"
UpdateClusternameInMemoryForNewCluster "New_Test_Cluster"
echo "Done updating tables with new clustername"

echo "Updating old cluster with new seeds"
SetOldDCSeeds "$dcone1_ip,$dctwo1_ip,$dcthree1_ip"
echo "Done updating old cluster with new seeds"

echo "Sleeping for 2 minutes to propagate changes"
sleep 120
