# operations include: prepare/cleanup/readwrite/readonly/writeonly/read_notrx
operation=writeonly
host=127.0.0.1
port=3306
pgsql_user=admin
password=password123
table_count=16
table_size=10000000
# concurrency
num_threads=32
# seconds that a test run
run_time=600
db=sbtest


if [[ ${operation} == 'prepare' ]]; then
   sysbench --db-driver=pgsql --pgsql-host=$host \
   --pgsql-port=$port --pgsql-user=$pgsql_user --pgsql-password=$password \
   --pgsql-db=$db --table_size=$table_size --tables=$table_count \
   --threads=$num_threads oltp_read_write prepare
elif [[ ${operation} == 'cleanup' ]]; then
  sysbench --db-driver=pgsql --pgsql-host=$host \
  --pgsql-port=$port --pgsql-user=$pgsql_user --pgsql-password=$password \
  --pgsql-db=$db --table_size=$table_size --tables=$table_count \
  --threads=$num_threads oltp_read_write cleanup
elif [[ ${operation} == 'readwrite' ]]; then
  sysbench --db-driver=pgsql --pgsql-host=$host \
  --pgsql-port=$port --pgsql-user=$pgsql_user --pgsql-password=$password \
  --pgsql-db=$db --table_size=$table_size --rand-type=uniform \
  --tables=$table_count --time=$run_time --threads=$num_threads \
  --report-interval=20 oltp_read_write run
elif [[ ${operation} == 'readonly' ]]; then
  sysbench --db-driver=pgsql --pgsql-host=$host \
  --pgsql-port=$port --pgsql-user=$pgsql_user --pgsql-password=$password \
  --pgsql-db=$db --table_size=$table_size --rand-type=uniform \
  --tables=$table_count --time=$run_time --threads=$num_threads \
  --report-interval=20 oltp_read_only run
elif [[ ${operation} == 'writeonly' ]]; then
  sysbench --db-driver=pgsql --pgsql-host=$host \
  --pgsql-port=$port --pgsql-user=$pgsql_user --pgsql-password=$password \
  --pgsql-db=$db --table_size=$table_size --rand-type=uniform \
  --tables=$table_count --time=$run_time --threads=$num_threads \
  --report-interval=20 oltp_write_only run
elif [[ ${operation} == 'read_notrx' ]]; then
  /usr/bin/sysbench --pgsql-host=$host --pgsql-port=$port \
  --pgsql-user=$pgsql_user --pgsql-password=$password --pgsql-db=$db \
  --oltp-tables-count=$table_count --oltp-table-size=$table_size --threads=$num_threads \
  --events=1000000000 --report-interval=10 --time=$run_time \
  --oltp-read-only=on \
  --oltp-skip-trx=on \
  /usr/share/sysbench/tests/include/oltp_legacy/oltp.lua run
fi
