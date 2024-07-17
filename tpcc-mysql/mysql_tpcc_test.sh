# operations include: schema/load/multi_load/run
operation=schema
host=127.0.0.1
port=3306
mysql_user=admin
password=pass
db=tpcc
# the number of warehouses, indicates the size of the test data set
ware_count=10
# the number of connections, means the concurrency
num_conn=100
run_time=86400

function concurrent_load(){
  HOST=$1
  PORT=$2
  USER=$3
  PASSWD=$4
  DBNAME=$5
  WH=$6
  STEP=100
  ./tpcc_load -h $HOST -P $PORT -u $USER -p $PASSWD -d $DBNAME -w $WH -l 1 -m 1 -n $WH >> 1.out &
  x=1
  while [ $x -le $WH ]
  do
    echo $x $(( $x + $STEP - 1 ))
    ./tpcc_load -h $HOST -P $PORT -u $USER -p $PASSWD -d $DBNAME -w $WH -l 2 -m $x -n $(( $x + $STEP - 1 ))  >> 2_$x.out &
    ./tpcc_load -h $HOST -P $PORT -u $USER -p $PASSWD -d $DBNAME -w $WH -l 3 -m $x -n $(( $x + $STEP - 1 ))  >> 3_$x.out &
    ./tpcc_load -h $HOST -P $PORT -u $USER -p $PASSWD -d $DBNAME -w $WH -l 4 -m $x -n $(( $x + $STEP - 1 ))  >> 4_$x.out &
    x=$(( $x + $STEP ))
  done
}


if [[ ${operation} == 'schema' ]]; then

    mysql -h$host -P$port -u$mysql_user -p$password $db < create_table.sql
elif [[ ${operation} == 'load' ]]; then
    ./tpcc_load -h$host -P$port -u$mysql_user -p$password -d$db -w $ware_count
    mysql -h$host -P$port -u$mysql_user -p$password $db < add_fkey_idx.sql
elif [[ ${operation} == 'multi_load' ]]; then
    mysql -h$host -P$port -u$mysql_user -p$password $db < add_fkey_idx.sql
    concurrent_load $host $port $mysql_user $password $db $ware_count
elif [[ ${operation} == 'run' ]]; then
    ./tpcc_start -h$host -P$port -u$mysql_user -p$password \
    -d$db -w$ware_count -c$num_conn -r10 -l$run_time
fi
