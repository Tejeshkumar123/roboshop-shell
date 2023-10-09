color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"
echo -e "\e[32m INSTALLING NODEJS REPO FILE$nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}
echo -e "\e[32m INSTALLING NODEJS SERVICE$nocolor"
yum install nodejs -y &>>${logfile}
echo -e "\e[32m ADDING USER AND LOCATION$nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "\e[32m DOWNLOADING NEW CONTENT  TO CART SERVICE$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${logfile}
unzip cart.zip &>>${logfile}
rm -rf cart.zip
echo -e "\e[32m installing the dependencies$nocolor"
npm install &>>${logfile}
echo -e "\e[32m CREATING CART SERVICE FILE$nocolor"
cp /root/repo-shell/cart.service /etc/systemd/system/cart.service
echo -e "\e[32m enabling and restarting the cart service$nocolor"
systemctl daemon-reload
systemctl enable cart &>>${logfile}
systemctl restart cart
