# operations include: prepare/cleanup/readwrite/readonly/writeonly/read_notrx
operation=writeonly
host=127.0.0.1
port=3306
mysql_user=admin
password=password123
table_count=16
table_size=10000000
# seconds that each test run
run_time=600
# the interval between each tests
run_interval=30
db=sbtest
# a set of concurrency apply to multi tests
threads=(4 8 16 32 64 128 256 512)



sysbench_prepare () {
   echo -e "[preparing data]"
   sysbench --db-driver=mysql --mysql-host=$host \
   --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
   --mysql-db=$db --table_size=$table_size --tables=$table_count \
   --threads=$table_count oltp_read_write prepare
}

sysbench_cleanup () {
  echo -e "[cleaning data]"
  sysbench --db-driver=mysql --mysql-host=$host \
  --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
  --mysql-db=$db --table_size=$table_size --tables=$table_count \
  --threads=$table_count oltp_read_write cleanup
}

sysbench_readwrite () {
  echo -e "[sysbench run readwrite]"
  for num_threads in ${threads[@]}; do
    echo "-------------------------------------------"
    echo running readwrite with threads number: $num_threads
      sysbench --db-driver=mysql --mysql-host=$host \
      --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
      --mysql-db=$db --table_size=$table_size --rand-type=uniform \
      --tables=$table_count --time=$run_time --threads=$num_threads \
      --report-interval=20 oltp_read_write run
    sleep $run_interval
  done
}


sysbench_readonly () {
  echo -e "[sysbench run readonly]"
  for num_threads in ${threads[@]}; do
    echo "-------------------------------------------"
    echo running readonly with threads number: $num_threads
      sysbench --db-driver=mysql --mysql-host=$host \
      --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
      --mysql-db=$db --table_size=$table_size --rand-type=uniform \
      --tables=$table_count --time=$run_time --threads=$num_threads \
      --report-interval=20 oltp_read_only run
    sleep $run_interval
  done
}

sysbench_writeonly () {
  echo -e "[sysbench run writeonly]"
  for num_threads in ${threads[@]}; do
    echo "-------------------------------------------"
    echo running writeonly with threads number: $num_threads
      sysbench --db-driver=mysql --mysql-host=$host \
      --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
      --mysql-db=$db --table_size=$table_size --rand-type=uniform \
      --tables=$table_count --time=$run_time --threads=$num_threads \
      --report-interval=20 oltp_write_only run
    sleep $run_interval
  done
}

sysbench_read_notrx () {
  echo -e "[sysbench run readonly with no transaction]"
  for num_threads in ${threads[@]}; do
    echo "-------------------------------------------"
    echo running no transaction read with threads number: $num_threads
      /usr/bin/sysbench --mysql-host=$host --mysql-port=$port \
      --mysql-user=$mysql_user --mysql-password=$password --mysql-db=$db \
      --oltp-tables-count=$table_count --oltp-table-size=$table_size --threads=$num_threads \
      --events=1000000000 --report-interval=10 --time=$run_time \
      --oltp-read-only=on \
      --oltp-skip-trx=on \
    sleep $run_interval
  done
}

if [[ ${operation} == 'prepare' ]]; then
    sysbench_prepare
elif [[ ${operation} == 'cleanup' ]]; then
    sysbench_cleanup
elif [[ ${operation} == 'readwrite' ]]; then
    sysbench_readwrite
elif [[ ${operation} == 'readonly' ]]; then
    sysbench_readonly
elif [[ ${operation} == 'writeonly' ]]; then
    sysbench_readwrite
elif [[ ${operation} == 'all' ]]; then
    sysbench_readwrite
    echo "###############################################"
    sleep $run_interval
    sysbench_readonly
    echo "###############################################"
    sleep $run_interval
    sysbench_writeonly
elif [[ ${operation} == 'read_notrx' ]]; then
    sysbench_read_notrx
fi