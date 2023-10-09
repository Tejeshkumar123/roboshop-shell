color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

echo -e "$color installing golang server $nocolor"
yum install golang -y &>>${logfile}
echo -e "$color installing golang server $nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color downloading new app contant ,dependencies and building software to dispatch $nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>${logfile}
unzip dispatch.zip &>>${logfile}
go mod init dispatch &>>${logfile}
go get &>>${logfile}
go build &>>${logfile}
echo -e "$color creating dispatch service file $nocolor"
cp /root/repo-shell/dispatch.service /etc/systemd/system/dispatch.service
echo -e "$color enabling and starting the dispatch service $nocolor"
systemctl daemon-reload
systemctl enable dispatch &>>${logfile}
systemctl restart dispatch