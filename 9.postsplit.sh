#!/bin/bash

echo "Set system_auth to replicate over the old 3 dc's on the old cluster"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3 } AND durable_writes = true;"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3 } AND durable_writes = true;"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3 } AND durable_writes = true;"
echo "Done setting system_auth to replicate over the old 3 dc's on the old cluster"

echo "Set system_auth to replicate over the new 3 dc's on the new cluster"
docker exec -i dcone91 cqlsh -e "ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3 } AND durable_writes = true;"
docker exec -i dcone91 cqlsh -e "ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3 } AND durable_writes = true;"
docker exec -i dcone91 cqlsh -e "ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone2' : 3, 'datacentertwo2' : 3, 'datacenterthree2' : 3 } AND durable_writes = true;"
echo "Done setting system_auth to replicate over the new 3 dc's on the new cluster"

echo "Sleeping for 2 minutes"
sleep 120