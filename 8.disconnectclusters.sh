#!/bin/bash

# Get bluenet & rednet network information
BLUENET_SUBNET=$(docker network inspect -f '{{range $k, $v := .IPAM.Config}}{{$v.Subnet}}{{end}}' bluenet)
REDNET_SUBNET=$(docker network inspect -f '{{range $k, $v := .IPAM.Config}}{{$v.Subnet}}{{end}}' rednet)

BLUENET_ADAPTER=$(ipdeel=`echo $BLUENET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' ` ; ifconfig | grep -B1 inet | grep -B1 ${ipdeel} | head -n1 | cut -f1 -d:)
REDNET_ADAPTER=$(ipdeel=`echo $REDNET_SUBNET |  awk -F. '{ print $1,".",$2}' | tr -d ' ' ` ; ifconfig | grep -B1 inet | grep -B1 ${ipdeel} | head -n1 | cut -f1 -d:)

# Close the bluenet to rednet and vice verse
iptables -D DOCKER-USER -i $BLUENET_ADAPTER -o $REDNET_ADAPTER -j ACCEPT
iptables -D DOCKER-USER -i $REDNET_ADAPTER -o $BLUENET_ADAPTER -j ACCEPT