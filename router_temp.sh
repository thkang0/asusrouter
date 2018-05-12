#!/bin/sh

dir=`dirname $0`

name="router_temp"
#columns="temp_24 temp_50"
col1="temp_24"
col2="temp_50"
columns="temp_24 temp_50"
p1=`wl -i eth1 phy_tempsense | awk '{ print $1 * .5 + 20 }'` # 2.4GHz
p2=`wl -i eth2 phy_tempsense | awk '{ print $1 * .5 + 20 }'` # 5.0GHz
points="$p1 $p2"
#$dir/todb.sh "$name" "$columns" "$points"

curl -POST 'http://influxdb:8086/write?db=mydb' --data-binary "$name $col1=$p1,$col2=$p2"
