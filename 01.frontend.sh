color="\e[32m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"

echo -e "$color INSTALLING NGINX SERVICE$nocolor"
yum install nginx -y &>>${logfile}
echo -e "$color REMOVING DEFAULT NGINX CONTENT$nocolor"
cd /usr/share/nginx/html
rm -rf *
echo -e  "$color DOWNLOADING NEW CONTENT TO NGINX$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${logfile}
unzip frontend.zip &>>${logfile}
rm -rf frontend.zip
echo -e  "$colorCONFIGURING REVERSE PROXY SERVER$nocolor"
cp /root/repo-shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf
echo -e "$color ENABLEING AND RESTARTING NGINX$nocolor"
systemctl enable nginx &>>${logfile}
systemctl restart nginx 