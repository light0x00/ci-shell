base_path=`dirname $(readlink "$0") &> /dev/null`
if [ -z $base_path ] ;then
    base_path=`dirname $0`
fi
src_base_path=`cd $base_path;cd ../src/ ; pwd`