#!/bin/sh

dir=`dirname $0`

name="router_cpu"
#columns="usr sys nic idle io irq sirq"
col0="usr"
col1="sys"
col2="nic"
col3="idle"
col4="io"
col5="irq"
col6="sirq"
#points=`top -bn1 | head -3 | awk '/CPU/ {print $2,$4,$6,$8,$10,$12,$14}' | sed 's/%//g'`
point0=`top -bn1 | head -3 | awk '/CPU/ {print $2}' | sed 's/%//g'`
point1=`top -bn1 | head -3 | awk '/CPU/ {print $4}' | sed 's/%//g'`
point2=`top -bn1 | head -3 | awk '/CPU/ {print $6}' | sed 's/%//g'`
point3=`top -bn1 | head -3 | awk '/CPU/ {print $8}' | sed 's/%//g'`
point4=`top -bn1 | head -3 | awk '/CPU/ {print $10}' | sed 's/%//g'`
point5=`top -bn1 | head -3 | awk '/CPU/ {print $12}' | sed 's/%//g'`
point6=`top -bn1 | head -3 | awk '/CPU/ {print $14}' | sed 's/%//g'`
#$dir/todb.sh "$name" "$columns" "$points"

curl -POST 'http://influxdb:8086/write?db=mydb' --data-binary "$name $col0=$point0,$col1=$point1,$col2=$point2,$col3=$point3,$col4=$point4,$col5=$point5,$col6=$point6"



