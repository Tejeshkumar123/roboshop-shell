color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"
echo -e "\e[32m installing python server\e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
echo -e "\e[32m adding user and location\e[0m"
useradd roboshop &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log
cd /app
echo -e "\e[32m downloading new content and dependencies to payment server\e[0m"
curl -O https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
unzip payment.zip &>>/tmp/payment.log
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
echo -e "\e[32m creating payment service\e[0m"
cp /root/repo-shell/payment.service /etc/systemd/system/payment.service
echo -e "\e[32m enabling and starting payment service\e[0m"
systemctl daemon-reload
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment
