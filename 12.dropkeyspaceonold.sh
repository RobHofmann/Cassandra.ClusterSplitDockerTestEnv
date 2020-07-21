#!/bin/bash

echo "Dropping user keyspace on old cluster"
echo "This SHOULD give an error (don't worry :))"
docker exec -i dcone1 cqlsh 127.0.0.1 -e "DROP KEYSPACE dummykeyspace;"
echo "Done dropping user keyspace on old cluster"
