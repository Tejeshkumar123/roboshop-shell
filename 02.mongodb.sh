color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"

echo -e  "$colorDOWNLOADING MONGODB REPO$nocolor"
cp /root/repo-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org -y &>>${logfile}
echo -e  "$colorCHANGING THE LISTEN ADDRESS$nocolor"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo -e "$color ENABLEING AND RESTARTING MONGODB SERVICE$nocolor"
systemctl enable mongod &>>${logfile}
systemctl restart mongod 