#!/bin/bash

# In the real situation this is the moment you would changeover your software from pointing to the current/old Cassandra nodes, to the new nodes.

# TODO: Change Cassandra YAML's to let them look at the right Seed nodes

echo "Set dummykeyspace to replicate over the 3 new dc's (remove from old)"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE dummykeyspace WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3 } AND durable_writes = true;"
echo "Done setting dummykeyspace to replicate over the 3 new dc's (remove from old)"
echo "Sleeping for 2 minutes"
sleep 120

echo "Checking data for dcone1"
docker exec -it dcone1 du -h /var/lib/cassandra/data --max-depth=1

echo "Cleanup old cluster"
docker exec -i dcone1 nodetool cleanup
docker exec -i dcone2 nodetool cleanup
docker exec -i dcone3 nodetool cleanup
docker exec -i dcone4 nodetool cleanup
docker exec -i dcone5 nodetool cleanup
docker exec -i dcone6 nodetool cleanup
docker exec -i dcone7 nodetool cleanup
docker exec -i dctwo1 nodetool cleanup
docker exec -i dctwo2 nodetool cleanup
docker exec -i dctwo3 nodetool cleanup
docker exec -i dctwo4 nodetool cleanup
docker exec -i dctwo5 nodetool cleanup
docker exec -i dctwo6 nodetool cleanup
docker exec -i dctwo7 nodetool cleanup
docker exec -i dcthree1 nodetool cleanup
docker exec -i dcthree2 nodetool cleanup
docker exec -i dcthree3 nodetool cleanup
docker exec -i dcthree4 nodetool cleanup
docker exec -i dcthree5 nodetool cleanup
docker exec -i dcthree6 nodetool cleanup
docker exec -i dcthree7 nodetool cleanup
echo "Done cleaning up old cluster"
echo "Sleeping for 2 minutes"
sleep 120

echo "Checking data for dcone1"
docker exec -it dcone1 du -h /var/lib/cassandra/data --max-depth=1