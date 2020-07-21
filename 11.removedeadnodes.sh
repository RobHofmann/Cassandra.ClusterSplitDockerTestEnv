#!/bin/bash

# Set IP's (var names will be $dcone1_ip $dctwo1_ip etc). Only for the "current" part of the cluster.
containers=$(docker ps --format "{{.Names}}")
for container in $containers
do
  ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
  tmpIpVarName="$container""_ip"
  eval $tmpIpVarName=\"$ip\"
done

echo "Removing dead nodes"
echo "Removing dcone91 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone91_ip
echo "Removing dcone92 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone92_ip
echo "Removing dcone93 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone93_ip
echo "Removing dcone94 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone94_ip
echo "Removing dcone95 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone95_ip
echo "Removing dcone96 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone96_ip
echo "Removing dcone97 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcone97_ip
echo "Removing dctwo91 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo91_ip
echo "Removing dctwo92 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo92_ip
echo "Removing dctwo93 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo93_ip
echo "Removing dctwo94 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo94_ip
echo "Removing dctwo95 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo95_ip
echo "Removing dctwo96 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo96_ip
echo "Removing dctwo97 from old cluster"
docker exec -i dcone1 nodetool assassinate $dctwo97_ip
echo "Removing dcthree91 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree91_ip
echo "Removing dcthree92 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree92_ip
echo "Removing dcthree93 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree93_ip
echo "Removing dcthree94 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree94_ip
echo "Removing dcthree95 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree95_ip
echo "Removing dcthree96 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree96_ip
echo "Removing dcthree97 from old cluster"
docker exec -i dcone1 nodetool assassinate $dcthree97_ip
echo "Removing dcone1 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone1_ip
echo "Removing dcone2 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone2_ip
echo "Removing dcone3 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone3_ip
echo "Removing dcone4 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone4_ip
echo "Removing dcone5 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone5_ip
echo "Removing dcone6 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone6_ip
echo "Removing dcone7 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcone7_ip
echo "Removing dctwo1 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo1_ip
echo "Removing dctwo2 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo2_ip
echo "Removing dctwo3 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo3_ip
echo "Removing dctwo4 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo4_ip
echo "Removing dctwo5 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo5_ip
echo "Removing dctwo6 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo6_ip
echo "Removing dctwo7 from new cluster"
docker exec -i dcone91 nodetool assassinate $dctwo7_ip
echo "Removing dcthree1 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree1_ip
echo "Removing dcthree2 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree2_ip
echo "Removing dcthree3 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree3_ip
echo "Removing dcthree4 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree4_ip
echo "Removing dcthree5 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree5_ip
echo "Removing dcthree6 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree6_ip
echo "Removing dcthree7 from new cluster"
docker exec -i dcone91 nodetool assassinate $dcthree7_ip
echo "Done removing dead nodes"