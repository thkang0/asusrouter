#!/bin/sh

dir=`dirname $0`

name="router_ping_ext"
#columns="dst ms"
col1="dst"
col2="ms"

pingdest="google"
p1="$pingdest"
p2=`ping -c1 -W1 www.google.com | grep 'seq=' | sed 's/.*time=\([0-9]*\.[0-9]*\).*$/\1/' | cut -f 1 -d '.'`
#points="$p1 $p2"
curl -POST 'http://influxdb:8086/write?db=mydb' --data-binary "$name $col1=\"google\",$col2=$p2 "
#$dir/todb.sh "$name" "$columns" "$points"


pingdest="KT"
p1="$pingdest"
p2=`ping -c1 -W1  168.126.63.1 | grep 'seq=' | sed 's/.*time=\([0-9]*\.[0-9]*\).*$/\1/' | cut -f 1 -d '.'`
#points="$p1 $p2"
#$dir/todb.sh "$name" "$columns" "$points"
curl -POST 'http://influxdb:8086/write?db=mydb' --data-binary "$name $col1=\"KT\",$col2=$p2 "
