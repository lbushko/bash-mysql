#!/bin/bash
export PATH=$PATH:/usr/local/mysql/bin/
#./mysql.sh -h ${HOST} -d${DB NAME} -t{timeout in seconds} -u{USER NAME} - p{PASSWORD}
trap "The execution of mysql_script has ended...." exit

while getopts "h:d:t:u:p:" option; do
 case $option in
    h) HOST=${OPTARG};;
    d) DB=${OPTARG};; #DB name
    t) TIME=${OPTARG};; #timeout
    u) USER=${OPTARG};;
    p) PASSWORD=${OPTARG};;
 esac
done

if [[ -z $HOST ]]
then
    echo 'Error: pls provide HOST with -h flag, example -h localhost'
    exit
fi

if [[ -z $TIME ]]
then
    TIME=60
fi

if [[ -z $USER ]]
then
    USER='root'
fi

COUNTER=0;
INTERVAL=5;

while [ $COUNTER -lt $TIME ]; do

RESULT=`mysqlshow -h $HOST -u $USER -p$PASSWORD $DB| grep -v Wildcard | grep -o $DB`

 if [ "$RESULT" == "$DB" ]; then
    echo 'YOUR DATABESE: "'$DB'" DATABASE EXISTS'
    mysql -h $HOST -u $USER -p$PASSWORD -e 'SELECT VERSION();'
    mysql -h $HOST -u $USER -p$PASSWORD -e 'show databases;'
    exit
 else
    echo 'YOUR DATABESE: "'$DB'" DOES NOT EXIST'
    echo 'Next try in '$INTERVAL' sec... pls wait!'
 fi
    COUNTER=$(($COUNTER+$INTERVAL))
    sleep $INTERVAL
    echo $COUNTER ' >> Executing.....'
done    
exit