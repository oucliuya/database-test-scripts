 #!/bin/bash
host=127.0.0.1
port=3306
mysql_user=admin
password=Liuya123
db=sbtest
table_size=10000000
table_count=16
run_time=300
threads=(1 2 4 8)
device=/dev/vdc

for num_threads in ${threads[@]}; do
  echo "${num_threads} threads read_write ======================="
  echo "start test:`date`"
  nohup   sysbench --db-driver=mysql --mysql-host=$host \
  --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
  --mysql-db=$db --table_size=$table_size --rand-type=uniform \
  --tables=$table_count --time=$run_time --threads=${num_threads} \
  --report-interval=20 oltp_read_write run > ${num_threads}_threads_read_write.log 2>&1 &
  nohup iostat -x -m 5 > ${num_threads}_threads_read_write_iostat.log 2>&1 &
  nohup  blktrace -d $device -o ${num_threads}_threads_read_write_blktrace.log -w 120 > ${num_threads}_threads_read_write_blk2.log 2>&1 &
  sleep 305
  pkill -9 iostat
  echo "end test:`date`"
  sleep 300
  echo "${num_threads} threads write_only ======================="
  echo "start test:`date`"
  nohup   sysbench --db-driver=mysql --mysql-host=$host \
  --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
  --mysql-db=$db --table_size=$table_size --rand-type=uniform \
  --tables=$table_count --time=$run_time --threads=${num_threads} \
  --report-interval=20 oltp_write_only run > ${num_threads}_threads_write_only.log 2>&1 &
  nohup iostat -x -m 5 > ${num_threads}_threads_write_only_iostat.log 2>&1 &
  nohup  blktrace -d $device -o ${num_threads}_threads_write_only_blktrace.log -w 120 > ${num_threads}_threads_write_only_blk2.log 2>&1 &
  sleep 305
  pkill -9 iostat
  echo "end test:`date`"
  sleep 300
  echo "${num_threads} threads read_only ======================="
  echo "start test:`date`"
  nohup   sysbench --db-driver=mysql --mysql-host=$host \
  --mysql-port=$port --mysql-user=$mysql_user --mysql-password=$password \
  --mysql-db=$db --table_size=$table_size --rand-type=uniform \
  --tables=$table_count --time=$run_time --threads=${num_threads} \
  --report-interval=20 oltp_read_only run > ${num_threads}_threads_read_only.log 2>&1 &
  nohup iostat -x -m 5 > ${num_threads}_threads_read_only_iostat.log 2>&1 &
  nohup  blktrace -d $device -o ${num_threads}_threads_read_only_blktrace.log -w 120 > ${num_threads}_threads_read_only_blk2.log 2>&1 &
  sleep 305
  pkill -9 iostat
  echo "end test:`date`"
done
