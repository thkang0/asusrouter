#!/bin/sh

maxint=4294967295
dir=`dirname $0`
scriptname=`basename $0`
old="/tmp/$scriptname.data.old"
new="/tmp/$scriptname.data.new"
old_epoch_file="/tmp/$scriptname.epoch.old"

old_epoch=`cat $old_epoch_file`
new_epoch=`date "+%s"`
echo $new_epoch > $old_epoch_file

interval=`expr $new_epoch - $old_epoch` # seconds since last sample

name="router_net"
#columns="interface recv_mbps recv_errs recv_drop trans_mbps trans_errs trans_drop"
col0="interface"
col1="recv_mbps"
col2="recv_errs"
col3="recv_drop"
col4="trans_mbps"
col5="trans_errs"
col6="trans_drop"

if [ -f $new ]; then
    awk -v old=$old -v interval=$interval -v maxint=$maxint '{
        getline line < old
        split(line, a)
        if( $1 == a[1] ) {
            recv_bytes  = $2 - a[2]
            trans_bytes = $5 - a[5]
            if(recv_bytes < 0) {recv_bytes = recv_bytes + maxint}    # maxint counter rollover
            if(trans_bytes < 0) {trans_bytes = trans_bytes + maxint} # maxint counter rollover
            recv_mbps  = (8 * (recv_bytes) / interval) / 1048576     # mbits per second
            trans_mbps = (8 * (trans_bytes) / interval) / 1048576    # mbits per second
            print $1, recv_mbps, $3 - a[3], $4 - a[4], trans_mbps, $6 - a[6], $7 - a[7]
        }
    }' $new  | while read line; do
        points="$line"
	p0=$(echo $points | cut -d ' ' -f 1 )
	p1=$(echo $points | cut -d ' ' -f 2 )
	p2=$(echo $points | cut -d ' ' -f 3 )
	p3=$(echo $points | cut -d ' ' -f 4 )
	p4=$(echo $points | cut -d ' ' -f 5 )
	p5=$(echo $points | cut -d ' ' -f 6 )
	p6=$(echo $points | cut -d ' ' -f 7 )
	curl -POST 'http://influxdb:8086/write?db=mydb' --data-binary "$name $col0=\"$p0\",$col1=$p1,$col2=$p2,$col3=$p3,$col4=$p4,$col5=$p5,$col6=$p6"
        #$dir/todb.sh "$name" "$columns" "$points"
        sleep 1
    done
    mv $new $old
fi

cat /proc/net/dev | tail +3 | tr ':|' '  ' | awk '{print $1,$2,$4,$5,$10,$12,$13}' > $new
