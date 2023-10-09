color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"
echo -e "$color DOWNLOADING NODEJS REPO$nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}
echo -e "$color INSTALLING NODEJS SERVICE$nocolor"
yum install nodejs -y &>>${logfile}
echo -e "$color ADDING USER AND LOCATION$nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color DOWNLOADING NEW CONTENT AND DEPENDENCIES$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${logfile}
unzip catalogue.zip &>>${logfile}
rm -rf catalogue.zip
npm install &>>${logfile}
echo -e "$color CREATING CATALOGUE SERVICE$nocolor"
cp /root/repo-shell/catalogue.service /etc/systemd/system/catalogue.service
echo -e "$color DOWNLOADING AND INSTALLING THE MONGODB SCHEMA$nocolor"
cp /root/repo-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y &>>${logfile}
mongo --host mongodb-dev.sindhu.cloud <${app_path}/schema/catalogue.js &>>${logfile}
echo -e "$color ENABLEING AND STARTING THE CATALOGUE SERVICE$nocolor"
systemctl daemon-reload
systemctl enable catalogue &>>${logfile}
systemctl restart catalogue