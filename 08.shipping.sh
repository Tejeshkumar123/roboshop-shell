color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"
echo -e "$color installing maven server$nocolor"
yum install maven -y &>>${logfile}
echo -e "$color adding user and location$nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color downloading new content to shipping service$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>${logfile}
unzip shipping.zip &>>${logfile}
echo -e "$color downloading dependencies and building application to shipping$nocolor"
mvn clean package &>>${logfile}
mv target/shipping-1.0.jar shipping.jar &>>${logfile}
echo -e "$color creating shipping service file$nocolor"
cp /root/repo-shell/shipping.service /etc/systemd/system/shipping.service
echo -e "$color downloading and installing mysql schema$nocolor"
yum install mysql -y &>>${logfile}
mysql -h mysql-dev.sindhu.cloud -uroot -pRoboShop@1 <${app_path}/schema/shipping.sql &>>${logfile}
echo -e "$color enabling and restarting the shipping service$nocolor"
systemctl daemon-reload
systemctl enable shipping &>>${logfile}
systemctl restart shipping
