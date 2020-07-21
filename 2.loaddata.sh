#!/bin/bash

echo "Set system_auth to replicate over the first 3 dc's"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3} AND durable_writes = true;"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3} AND durable_writes = true;"
docker exec -i dcone1 cqlsh -e "ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenterone' : 3, 'datacentertwo' : 3, 'datacenterthree' : 3} AND durable_writes = true;"
echo "system_auth replication factor is now 3 in each dc"
echo "Sleeping for 2 minutes"
sleep 120
echo "Loading keyspace"
docker exec -i dcone1 bash -c "cqlsh -f '/cassdata/dummykeyspace.keyspace'"
echo "Done loading keyspace"
echo "Sleeping for 10 seconds"
sleep 10
echo "Loading table"
docker exec -i dcone1 bash -c "cqlsh -f '/cassdata/dummykeyspace.dummytable.table'"
echo "Done loading table"
echo "Sleeping for 5 minutes"
sleep 300
echo "Loading data"
docker exec -i dcone1 cqlsh -e "copy dummykeyspace.dummytable from '/cassdata/dummykeyspace.dummytable.csv'"
echo "Done loading data"