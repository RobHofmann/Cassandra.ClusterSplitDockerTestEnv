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

# Get bluenet & rednet network information
BLUENET_SUBNET=$(docker network inspect -f '{{range $k, $v := .IPAM.Config}}{{$v.Subnet}}{{end}}' bluenet)
REDNET_SUBNET=$(docker network inspect -f '{{range $k, $v := .IPAM.Config}}{{$v.Subnet}}{{end}}' rednet)

BLUENET_IPPREFIX=`echo $BLUENET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' `
REDNET_IPPREFIX=`echo $REDNET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' `

BLUENET_ADAPTER=$(ipdeel=`echo $BLUENET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' ` ; ifconfig | grep -B1 inet | grep -B1 ${ipdeel} | head -n1 | cut -f1 -d:)
REDNET_ADAPTER=$(ipdeel=`echo $REDNET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' ` ; ifconfig | grep -B1 inet | grep -B1 ${ipdeel} | head -n1 | cut -f1 -d:)

# Open the bluenet to rednet and vice verse
iptables -I DOCKER-USER -i $BLUENET_ADAPTER -o $REDNET_ADAPTER -j ACCEPT
iptables -I DOCKER-USER -i $REDNET_ADAPTER -o $BLUENET_ADAPTER -j ACCEPT

# Set IP's (var names will be $dcone1_ip $dctwo1_ip etc). Only for the "current" part of the cluster.
containers=$(docker ps --format "{{.Names}}")
for container in $containers
do
  ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
  tmpIpVdcthreeame="$container""_ip"
  eval $tmpIpVdcthreeame=\"$ip\"
done

# Boot "New" Cluster
docker run -d --name dcone91 --network=rednet --ip="$REDNET_IPPREFIX.0.2" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone91.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
dcone91_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dcone91)
SetDCSeeds "$dcone1_ip,$dctwo1_ip,$dcthree1_ip,$dcone91_ip"
docker run -d --name dcone92 --network=rednet --ip="$REDNET_IPPREFIX.0.3" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone92.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dcone93 --network=rednet --ip="$REDNET_IPPREFIX.0.4" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone93.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dcone94 --network=rednet --ip="$REDNET_IPPREFIX.0.5" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone94.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dcone95 --network=rednet --ip="$REDNET_IPPREFIX.0.6" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone95.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dcone96 --network=rednet --ip="$REDNET_IPPREFIX.0.7" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone96.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dcone97 --network=rednet --ip="$REDNET_IPPREFIX.0.8" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcone97.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterone2 -e CASSANDRA_RACK=ZA3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dctwo91 --network=rednet --ip="$REDNET_IPPREFIX.0.9" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo91.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
dctwo91_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dctwo91)
SetDCSeeds "$dcone1_ip,$dctwo1_ip,$dcthree1_ip,$dcone91_ip,$dctwo91_ip"
docker run -d --name dctwo92 --network=rednet --ip="$REDNET_IPPREFIX.0.10" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo92.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dctwo93 --network=rednet --ip="$REDNET_IPPREFIX.0.11" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo93.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dctwo94 --network=rednet --ip="$REDNET_IPPREFIX.0.12" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo94.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dctwo95 --network=rednet --ip="$REDNET_IPPREFIX.0.13" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo95.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dctwo96 --network=rednet --ip="$REDNET_IPPREFIX.0.14" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo96.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dctwo97 --network=rednet --ip="$REDNET_IPPREFIX.0.15" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dctwo97.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacentertwo2 -e CASSANDRA_RACK=ZR3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
docker run -d --name dcthree91 --network=rednet --ip="$REDNET_IPPREFIX.0.16" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree91.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 90
dcthree91_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dcthree91)
SetDCSeeds "$dcone1_ip,$dctwo1_ip,$dcthree1_ip,$dcone91_ip,$dctwo91_ip,$dcthree91_ip"
docker run -d --name dcthree92 --network=rednet --ip="$REDNET_IPPREFIX.0.17" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree92.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN1 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 120
docker run -d --name dcthree93 --network=rednet --ip="$REDNET_IPPREFIX.0.18" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree93.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 120
docker run -d --name dcthree94 --network=rednet --ip="$REDNET_IPPREFIX.0.19" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree94.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN2 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 120
docker run -d --name dcthree95 --network=rednet --ip="$REDNET_IPPREFIX.0.20" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree95.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 120
docker run -d --name dcthree96 --network=rednet --ip="$REDNET_IPPREFIX.0.21" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree96.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 120
docker run -d --name dcthree97 --network=rednet --ip="$REDNET_IPPREFIX.0.22" --security-opt seccomp=unconfined --restart=unless-stopped -v "cassdata":"/cassdata" -v "cassandrayaml/cassandra_dcthree97.yaml":"/etc/cassandraconf/cassandra.yaml" -e HEAP_NEWSIZE=256M -e MAX_HEAP_SIZE=1G -e CASSANDRA_DC=datacenterthree2 -e CASSANDRA_RACK=ZN3 -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch cassandra -Dcassandra.config=file:///etc/cassandraconf/cassandra.yaml
sleep 120
