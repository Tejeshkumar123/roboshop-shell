color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"

echo -e "$color disabling mysql defult version$nocolor"
yum module disable mysql -y &>>${logfile}
echo -e "$color setting mysql repo$nocolor"
cp /root/repo-shell/mysql.repo /etc/yum.repos.d/mysql.repo
echo -e "$color installing mysql server$nocolor"
yum install mysql-community-server -y &>>${logfile}
echo -e "$color changing defult root password$nocolor"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${logfile}
echo -e "$color enabling and starting mysql server$nocolor"
systemctl enable mysqld &>>${logfile}
systemctl restart mysqld

