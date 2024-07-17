branch=master
charset=utf8mb4
collation=utf8mb4_0900_ai_ci
install_dir=/root/xxx/yyy
debug=1



date=$(date +%Y%m%d%H%M)
cd /home/tester/source
source /opt/rh/devtoolset-8/enable
rm -rf MySQL-8.0.32
git clone ssh://xxx.com:23/DBMS/MySQL-8.0.32.git
cd /home/tester/source/MySQL-8.0.32
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
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_DEBUG=$debug \
    -DDOWNLOAD_BOOST=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_BOOST=/home/tester/source/boost/boost_1_77_0 \
    -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF
make -j`nproc` && make install