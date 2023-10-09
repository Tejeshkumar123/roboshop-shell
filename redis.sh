color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${logfile}
yum module enable redis:remi-6.2 -y &>>${logfile}
echo -e "$color installing the redis\e[0m"
yum install redis -y &>>${logfile}
echo -e "$color changing the listen address\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
echo -e "$color enabling and restarting the redis\e[0m"
systemctl enable redis &>>${logfile}
systemctl restart redis