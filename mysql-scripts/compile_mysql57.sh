branch=master
charset=latin1
collation=latin1_swedish_ci
install_dir=/root/xxx/yyy
debug=1

date=$(date +%Y%m%d%H%M)
cd /home/tester/source
mv MySQL-5.7.39 MySQL-5.7.39.$date
git clone ssh://xxx.com:23/DBMS/MySQL-5.7.39.git
cd /home/tester/source/MySQL-5.7.39
git pull
git checkout $branch
git status
rm -rf build
mv $install_dir $install_dir.$date
mkdir build
cd build
make clean
cmake .. \
    -DCMAKE_INSTALL_PREFIX=$install_dir \
    -DMYSQL_DATADIR=$install_dir/data \
    -DDEFAULT_CHARSET=$charset \
    -DDEFAULT_COLLATION=$collation \
    -DEXTRA_CHARSETS=all \
    -DWITH_DEBUG=$debug \
    -DWITH_BOOST=/home/tester/source/MySQL-5.7.39/boost/boost_1_59_0 \
    -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF
make -j8 && make install
$install_dir/bin/mysqld --version