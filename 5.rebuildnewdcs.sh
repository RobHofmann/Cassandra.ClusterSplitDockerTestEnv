#!/bin/bash

echo "Rebuilding the new DC's"
echo "Rebuilding dcone91"
docker exec -i dcone91 nodetool rebuild datacenterone
echo "Rebuilding dcone92"
docker exec -i dcone92 nodetool rebuild datacenterone
echo "Rebuilding dcone93"
docker exec -i dcone93 nodetool rebuild datacenterone
echo "Rebuilding dcone94"
docker exec -i dcone94 nodetool rebuild datacenterone
echo "Rebuilding dcone95"
docker exec -i dcone95 nodetool rebuild datacenterone
echo "Rebuilding dcone96"
docker exec -i dcone96 nodetool rebuild datacenterone
echo "Rebuilding dcone97"
docker exec -i dcone97 nodetool rebuild datacenterone
echo "Rebuilding dctwo91"
docker exec -i dctwo91 nodetool rebuild datacentertwo
echo "Rebuilding dctwo92"
docker exec -i dctwo92 nodetool rebuild datacentertwo
echo "Rebuilding dctwo93"
docker exec -i dctwo93 nodetool rebuild datacentertwo
echo "Rebuilding dctwo94"
docker exec -i dctwo94 nodetool rebuild datacentertwo
echo "Rebuilding dctwo95"
docker exec -i dctwo95 nodetool rebuild datacentertwo
echo "Rebuilding dctwo96"
docker exec -i dctwo96 nodetool rebuild datacentertwo
echo "Rebuilding dctwo97"
docker exec -i dctwo97 nodetool rebuild datacentertwo
echo "Rebuilding dcthree91"
docker exec -i dcthree91 nodetool rebuild datacenterthree
echo "Rebuilding dcthree92"
docker exec -i dcthree92 nodetool rebuild datacenterthree
echo "Rebuilding dcthree93"
docker exec -i dcthree93 nodetool rebuild datacenterthree
echo "Rebuilding dcthree94"
docker exec -i dcthree94 nodetool rebuild datacenterthree
echo "Rebuilding dcthree95"
docker exec -i dcthree95 nodetool rebuild datacenterthree
echo "Rebuilding dcthree96"
docker exec -i dcthree96 nodetool rebuild datacenterthree
echo "Rebuilding dcthree97"
docker exec -i dcthree97 nodetool rebuild datacenterthree
echo "Done rebuilding the new DC's"
echo "Sleep for 3 minutes to make sure data has been distributed"
sleep 180
echo "Done sleeping"