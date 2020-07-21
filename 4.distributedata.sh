#!/bin/bash

echo "Set system_auth to replicate over all 6 dc's"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3, 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3} AND durable_writes = true;"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3, 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3} AND durable_writes = true;"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3, 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3} AND durable_writes = true;"
echo "system_auth replication factor is now 3 in all dc's"
echo "Sleeping for 2 minutes"
sleep 120
echo "Set dummykeyspace to replicate over all 6 dc's"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE dummykeyspace WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3, 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3 } AND durable_writes = true;"
echo "dummykeyspace replication factor is now 3 in all dc's"
echo "Sleeping for 2 minutes"
sleep 120