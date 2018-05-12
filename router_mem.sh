#!/bin/sh

dir=`dirname $0`

name="router_mem"
#columns="used_kb free_kb"
column0="used_kb"
column1="free_kb"
#points=`top -bn1 | head -3 | awk '/Mem/ {print $2,$4}' | sed 's/K//g'`
point0=`top -bn1 | head -3 | awk '/Mem/ {print $2}' | sed 's/K//g'`
point1=`top -bn1 | head -3 | awk '/Mem/ {print $4}' | sed 's/K//g'`
#echo $point0
#echo $point1
#$dir/todb.sh "$name" "$columns" "$points"
curl -POST 'http://influxdb:8086/write?db=mydb' --data-binary "$name $column0=$point0,$column1=$point1 "
