color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

nodejs()
{

echo -e "$color DOWNLOADING NODEJS REPO$nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}
echo -e "$color INSTALLING NODEJS SERVICE$nocolor"
yum install nodejs -y &>>${logfile}
app_start
npm install &>>${logfile}
service_start
}
app_start()
{
  echo -e "$color ADDING USER AND LOCATION$nocolor"
  useradd roboshop &>>${logfile}
  mkdir ${app_path} &>>${logfile}
  cd ${app_path}
  rm -rf *
  echo -e "$color DOWNLOADING NEW CONTENT AND DEPENDENCIES$nocolor"
  curl -O https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${logfile}
  unzip ${component}.zip &>>${logfile}
  rm -rf ${component}.zip
}
mongo_schema()
{
echo -e "$color DOWNLOADING AND INSTALLING THE MONGODB SCHEMA$nocolor"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y &>>${logfile}
mongo --host mongodb-dev.sindhu.cloud <${app_path}/schema/${component}.js &>>${logfile}
}
service_start()
{
  echo -e "$color CREATING ${component} SERVICE$nocolor"
  cp /root/roboshop-shell/${component}.service /etc/systemd/system/${component}.service
  echo -e "$color ENABLEING AND STARTING THE ${component} SERVICE$nocolor"
  systemctl daemon-reload
  systemctl enable ${component} &>>${logfile}
  systemctl restart ${component}
}