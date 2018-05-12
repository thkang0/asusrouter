#/bin/sh

dbname="mydb"
dbhost="influxdb:8086"
user="root"
passwd="root"

if [ $# -ne 3 ]; then
    echo "Usage: $0 \"series name\" \"columns\" \"points\""
    exit
fi

name="\"$1\""
columns=`echo $2 | sed 's/^\(.*\)$/"\1"/' | sed 's/ /","/g'`
points=`echo $3 | sed 's/\([a-zA-Z0-9\.]*[a-zA-Z][a-zA-Z0-9\.]*\)/"\1"/g' | sed 's/ /,/g'`

payload=`cat` <<- EOT
    [{
      "name":$name,
      "columns":[$columns],
      "points":[[$points]]
    }]
EOT


#wget --quiet --post-data "$payload" "http://$dbhost/db/$dbname/series?u=$user&p=$passwd" -O /dev/null

#curl -POST 'http://$dbhost/write?db=$dbname' --data-binary '$name usr=0.0,sys=8.3,nic=0.0,idle=91.6,io=0.0,irq=0.0,sirq=0.0'

