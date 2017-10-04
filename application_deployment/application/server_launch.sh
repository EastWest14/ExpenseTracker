set -e
cd /home/ec2-user
sudo pkill -9 python
./main &>/dev/null &disown