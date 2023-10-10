color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

status()
{
  if [ $? -eq 0 ];then
    echo Success
  else
    echo failure
  fi
}

nodejs()
{
echo -e "$color DOWNLOADING NODEJS REPO$nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}
status
echo -e "$color INSTALLING NODEJS SERVICE$nocolor"
yum install nodejs -y &>>${logfile}
status
app_start
npm install &>>${logfile}
status
service_start
}

app_start()
{
  echo -e "$color ADDING USER AND LOCATION$nocolor"
  useradd roboshop &>>${logfile}
  status
  echo -e "$color creating default app path$nocolor"
  mkdir ${app_path} &>>${logfile}
  status
  cd ${app_path}
  rm -rf *
  echo -e "$color DOWNLOADING NEW CONTENT AND DEPENDENCIES$nocolor"
  curl -O https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${logfile}
  unzip ${component}.zip &>>${logfile}
  status
  rm -rf ${component}.zip
}

mongo_schema()
{
echo -e "$color DOWNLOADING AND INSTALLING THE MONGODB SCHEMA$nocolor"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
status
echo -e "$color Installing Mongo schema$nocolor"
yum install mongodb-org-shell -y &>>${logfile}
status
echo -e "$color Loading schema$nocolor"
mongo --host mongodb-dev.sindhu.cloud <${app_path}/schema/${component}.js &>>${logfile}
status
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

maven()
{
  echo -e "$color installing maven server$nocolor"
  yum install maven -y &>>${logfile}
  app_start
  echo -e "$color downloading dependencies and building application to shipping$nocolor"
  mvn clean package &>>${logfile}
  mv target/shipping-1.0.jar shipping.jar &>>${logfile}
  mysql_schema
  service_start
}

mysql_schema()
{
  echo -e "$color downloading and installing mysql schema$nocolor"
  yum install mysql -y &>>${logfile}
  mysql -h mysql-dev.sindhu.cloud -uroot -pRoboShop@1 <${app_path}/schema/shipping.sql &>>${logfile}

}

python()
{
  echo -e "\e[32m installing python server\e[0m"
  yum install python36 gcc python3-devel -y &>>${logfile}
  app_start
  echo -e "$color downloading dependencies for python service$nocolor"
  pip3.6 install -r requirements.txt &>>${logfile}
  service_start
}