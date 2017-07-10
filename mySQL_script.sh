#!/usr/bin/env bash
#./mysql.sh -p ${path} -d${database name} -t{timeout in seconds}
trap "echo Sorry. You have aborted execution of a shell script" INT

while getopts p:d:t option
do
 case "${option}"
 in
 p) PATH=${OPTARG};; #localhost
 d) DB=${OPTARG};; #DB name
 t) TIME=${OPTARG};; #timeout
 esac
done

if [[ -z $PATH ]]
then
    return
fi

if [[ -z $TIME ]]
then
    TIME=60
fi

mysql -h localhost -u USERNAME -p
# To check if provided DB exists on MYSQL:

COUNTER=0;
INTERVAL=5;
while [ $COUNTER - lt TIME ]; do
    if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$DB'" 2>&1`" ]];
        then
            echo "YOUR $DB DATABASE EXISTS"
            mysql -e "SELECT VERSION();"
            mysql -e 'show databases;'
            return
        else
            echo "YOUR $DB DOES NOT EXIST" #it should be commented
        fi
    COUNTER = $COUNTER + $INTERVAL
    sleep $INTERVAL
done

return