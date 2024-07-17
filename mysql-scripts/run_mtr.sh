# single/suite
operation=suite
# all: run all suites
# main: run suite main
# innodb: run suite innodb
# main.select_all: run single
name=all
# the mysql root dir
install_dir=/root/xxx/yyy



echo "mysqld version is:"
$install_dir/bin/mysqld --version
date=$(date +%Y%m%d%H%M)
cp -ar $install_dir/mysql-test $install_dir/mysql-test.$date
cd $install_dir/mysql-test

if [[ ${operation} == 'single' ]]; then
   ./mysql-test-run.pl ${name}
elif [[ ${operation} == 'suite' && ${name} == 'all' ]]; then
  ./mysql-test-run.pl --force --max-test-fail=0 --suite-timeout=600
elif [[ ${operation} == 'suite' ]]; then
  ./mysql-test-run.pl --force --suite=${name} --max-test-fail=0 --suite-timeout=600
fi
