set -e
cd /home/ec2-user
sudo pkill -9 python
. ./set_env.sh
./main &>/dev/null &disown