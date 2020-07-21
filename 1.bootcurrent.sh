#!/bin/bash

function SetDCSeeds {
    echo "Setting seeds for DC's"
    for filename in \
        `ls cassandrayaml | grep "cassandra_dcone9"` \
        `ls cassandrayaml | grep "cassandra_dctwo9"` \
        `ls cassandrayaml | grep "cassandra_dcthree9"` \
        `ls cassandrayaml | grep "cassandra_dcone" | grep -v 9` \
        `ls cassandrayaml | grep "cassandra_dctwo" | grep -v 9` \
        `ls cassandrayaml | grep "cassandra_dcthree" | grep -v 9` \
    ; do
        sed -i -r 's/(- seeds:).*/\1 "'"$1"'"/' cassandrayaml/$filename
    done
    echo "Done setting seeds for DC's"
}

function SetClusterName {
    echo "Setting cluster names in YAML's"
    for filename in \
        `ls cassandrayaml | grep "cassandra_dcone9"` \
        `ls cassandrayaml | grep "cassandra_dctwo9"` \
        `ls cassandrayaml | grep "cassandra_dcthree9"` \
        `ls cassandrayaml | grep "cassandra_dcone" | grep -v 9` \
        `ls cassandrayaml | grep "cassandra_dctwo" | grep -v 9` \
        `ls cassandrayaml | grep "cassandra_dcthree" | grep -v 9` \
    ; do
        sed -i -r 's/^(# )?('"cluster_name"':).*/\2 '"$1"'/' cassandrayaml/$filename
    done
    echo "Done setting cluster names in YAML's"
}

echo "Cleanup old stuff"
docker rm --force $(docker ps -a -q) || true
docker rmi --force $(docker images -q) || true
docker volume rm --force $(docker volume ls -q) || true
docker network rm bluenet || true
docker network rm rednet || true
docker network create bluenet --subnet 172.19.0.0/16 || true
docker network create rednet --subnet 172.18.0.0/16 || true
echo "Done cleaning up old stuff"

SetClusterName "Test_Cluster"

# Get bluenet & rednet network information
BLUENET_SUBNET=$(docker network inspect -f '{{range $k, $v := .IPAM.Config}}{{$v.Subnet}}{{end}}' bluenet)
REDNET_SUBNET=$(docker network inspect -f '{{range $k, $v := .IPAM.Config}}{{$v.Subnet}}{{end}}' rednet)

BLUENET_IPPREFIX=`echo $BLUENET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' `
REDNET_IPPREFIX=`echo $REDNET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' `


sed -i -r 's/(- seeds:).*/\1 "'"$BLUENET_IPPREFIX.0.2"'"/' cassandrayaml/cassandra_dcone1.yaml
docker run -d --name dcone1 --network=bluenet --ip="$BLUENET_IPPREFIX.0.2" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone1.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
dcone1_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dcone1)
SetDCSeeds "$dcone1_ip"
sleep 60
docker run -d --name dcone2 --network=bluenet --ip="$BLUENET_IPPREFIX.0.3" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone2.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcone3 --network=bluenet --ip="$BLUENET_IPPREFIX.0.4" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone3.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcone4 --network=bluenet --ip="$BLUENET_IPPREFIX.0.5" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone4.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcone5 --network=bluenet --ip="$BLUENET_IPPREFIX.0.6" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone5.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcone6 --network=bluenet --ip="$BLUENET_IPPREFIX.0.7" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone6.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcone7 --network=bluenet --ip="$BLUENET_IPPREFIX.0.8" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcone7.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone -e CASSANDRA_RACK=RA3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dctwo1 --network=bluenet --ip="$BLUENET_IPPREFIX.0.9" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo1.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
dctwo1_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dcone1)
SetDCSeeds "$dcone1_ip,$dctwo1_ip"
sleep 60
docker run -d --name dctwo2 --network=bluenet --ip="$BLUENET_IPPREFIX.0.10" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo2.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dctwo3 --network=bluenet --ip="$BLUENET_IPPREFIX.0.11" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo3.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dctwo4 --network=bluenet --ip="$BLUENET_IPPREFIX.0.12" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo4.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dctwo5 --network=bluenet --ip="$BLUENET_IPPREFIX.0.13" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo5.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dctwo6 --network=bluenet --ip="$BLUENET_IPPREFIX.0.14" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo6.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dctwo7 --network=bluenet --ip="$BLUENET_IPPREFIX.0.15" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dctwo7.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo -e CASSANDRA_RACK=RR3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcthree1 --network=bluenet --ip="$BLUENET_IPPREFIX.0.16" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree1.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
dcthree1_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dcone1)
SetDCSeeds "$dcone1_ip,$dctwo1_ip,$dcthree1_ip"
sleep 60
docker run -d --name dcthree2 --network=bluenet --ip="$BLUENET_IPPREFIX.0.17" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree2.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcthree3 --network=bluenet --ip="$BLUENET_IPPREFIX.0.18" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree3.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcthree4 --network=bluenet --ip="$BLUENET_IPPREFIX.0.19" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree4.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcthree5 --network=bluenet --ip="$BLUENET_IPPREFIX.0.20" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree5.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcthree6 --network=bluenet --ip="$BLUENET_IPPREFIX.0.21" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree6.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
docker run -d --name dcthree7 --network=bluenet --ip="$BLUENET_IPPREFIX.0.22" --security-opt seccomp=unconfined --restart=unless-stopped -v "$(pwd)/cassdata":"/cassdata" -v "$(pwd)/cassandrayaml/cassandra_dcthree7.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree -e CASSANDRA_RACK=RN3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 60
