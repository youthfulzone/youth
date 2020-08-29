#!/bin/sh
-get update -y
DEBIAN_FRONTEND=noninteractive \
apt-get \
-o Dpkg::Options::="--force-confnew" \
--force-yes \
-fuy \
dist-upgrade
if [ $1 = "initial" ]; then
apt
if grep "#Port 22" /etc/ssh/sshd_config >/dev/null 2>&1; then
newport=$(shuf -i 1024-65535 -n 1)
sed -i "s/#Port 22/Port $newport/g" /etc/ssh/sshd_config
elif ! grep "#Port 22" /etc/ssh/sshd_config >/dev/null 2>&1; then
echo "SSH: Portul SSH a fost deja schimbat."
else
echo "Eroare setare port SSH."
fi
if grep "Port 22" /etc/ssh/sshd_config >/dev/null 2>&1; then
newport=$(shuf -i 1024-65535 -n 1)
sed -i "s/Port 22/Port $newport/g" /etc/ssh/sshd_config
elif ! grep "Port 22" /etc/ssh/sshd_config >/dev/null 2>&1; then
echo "SSH: Portul SSH a fost deja schimbat."
else
echo "Eroare setare port SSH."
fi
service sshd restart -y
service ssh restart -y

if grep 'PermitRootLogin yes' /etc/ssh/sshd_config >/dev/null 2>&1; then
sed -i "s|PermitRootLogin yes|PermitRootLogin no|g" /etc/ssh/sshd_config
elif ! grep 'PermitRootLogin no' /etc/ssh/sshd_config >/dev/null 2>&1; then
echo "SSH: Root login a fost revocat."
else
echo "Eroare: Revocare root login esuata."
fi

if ! dpkg --get-selections | grep vsftpd >/dev/null 2>&1; then
sudo apt-get install vsftpd
elif dpkg --get-selections | grep vsftpd >/dev/null 2>&1; then
echo "vsFTPD: vsFTPD este deja instalat."
else
echo "Eroare configurare vsFTPD."
fi

if [ ! -s "/var/log/vsftpd.log" ]; then
touch /var/log/vsftpd.log
elif [ -s "/var/log/vsftpd.log" ]; then
echo "vsFTPD: Fisierul inregistrarilor de logare este deja configurat."
else
echo "Eroare configurare fisier de inregistrare de logare."
fi

if grep '#write_enable=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
sed -i "s|#write_enable=YES|write_enable=YES|g" /etc/vsftpd.conf
elif ! grep '#write_enable=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: write_enable=YES este deja configurat."
else
echo "Eroare: Configurare write_enable=YES esuata."
fi

if grep '#chroot_local_user=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
sed -i "s|#chroot_local_user=YES|chroot_local_user=YES|g" /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf
elif ! grep '#chroot_local_user=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: chroot_local_user=YES este deja configurat."
else
echo "Eroare: Configurare chroot_local_user=YES esuata."
fi

if ! grep 'user_sub_token=\$USER' /etc/vsftpd.conf >/dev/null 2>&1; then
echo 'user_sub_token=$USER' >> /etc/vsftpd.conf
elif grep 'user_sub_token=$USER' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: user_sub_token=$USER este deja configurat."
else
echo "Eroare: Configurare user_sub_token=$USER esuata."
fi

if ! grep 'local_root=/home/\$USER/ftp' /etc/vsftpd.conf >/dev/null 2>&1; then
echo 'local_root=/home/$USER/ftp' >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf
elif grep 'local_root=/home/$USER/ftp' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: local_root=/home/$USER/ftp este deja configurat."
else
echo "Eroare: Configurare local_root=/home/$USER/ftp esuata."
fi

if ! grep 'pasv_min_port=40000' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "pasv_min_port=40000" >> /etc/vsftpd.conf
elif grep 'pasv_min_port=40000' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: pasv_min_port=40000 este deja configurat."
else
echo "Eroare: Configurare pasv_min_port=40000 esuata."
fi

if ! grep 'pasv_max_port=50000' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "pasv_max_port=50000" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf
elif grep 'pasv_max_port=50000' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: pasv_max_port=50000 este deja configurat."
else
echo "Eroare: Configurare pasv_max_port=50000 esuata."
fi

if ! grep 'userlist_enable=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "userlist_enable=YES" >> /etc/vsftpd.conf
elif grep 'userlist_enable=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: userlist_enable=YES este deja configurat."
else
echo "Eroare: Configurare userlist_enable=YES esuata."
fi

if ! grep 'userlist_file=/etc/vsftpd.userlist' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf
elif grep 'userlist_file=/etc/vsftpd.userlist' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: userlist_file=/etc/vsftpd.userlist este deja configurat."
else
echo "Eroare: Configurare userlist_file=/etc/vsftpd.userlist esuata."
fi

if ! grep 'userlist_deny=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "userlist_deny=NO" >> /etc/vsftpd.conf
elif grep 'userlist_deny=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: userlist_deny=NO este deja configurat."
else
echo " Eroare: Configurare userlist_deny=NO esuata."
fi

if ! grep "$sftpuser" /etc/vsftpd.userlist >/dev/null 2>&1; then
echo "$sftpuser" | sudo tee -a /etc/vsftpd.userlist
elif grep "$sftpuser" /etc/vsftpd.userlist >/dev/null 2>&1; then
echo "vsFTPD: Userul a fost deja inregistrat in /etc/vsftpd.userlist."
else
echo "Eroare: Inregistrarea USERului in /etc/vsftpd.userlist esuata."
fi
sudo systemctl restart vsftpd

if [ ! -f "/etc/ssl/private/vsftpd.pem" ] >/dev/null 2>&1; then
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -subj "/C=RO/ST=.../L=Stockholm /O=.../OU=.../CN=fishy.ro/emailAddress=..."
elif [ -f "/etc/ssl/private/vsftpd.pem" ] >/dev/null 2>&1; then
echo "vsFTPD: Certificatul SSL este deja configurat."
else
echo "Eroare: Configurare Certificat SSL esuata."
fi

if ! grep '#rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem' /etc/vsftpd.conf >/dev/null 2>&1; then
sed -i "s|rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem|#rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem|g" /etc/vsftpd.conf
elif grep '#rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem este deja comentat."
else
echo "Eroare: Comentare rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem esuata. "
fi

if ! grep '#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key' /etc/vsftpd.conf >/dev/null 2>&1; then
sed -i "s|rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key|#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key|g" /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf
elif grep '#rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key este deja comentat."
else
echo "Eroare: Comentare rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key esuata."
fi

if ! grep 'rsa_cert_file=/etc/ssl/private/vsftpd.pem' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem" >> /etc/vsftpd.conf
elif grep 'rsa_cert_file=/etc/ssl/private/vsftpd.pem' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: rsa_cert_file=/etc/ssl/private/vsftpd.pem este deja configurat."
else
echo "Eroare: Configurare rsa_cert_file=/etc/ssl/private/vsftpd.pem esuata."
fi

if ! grep 'rsa_private_key_file=/etc/ssl/private/vsftpd.pem' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "rsa_private_key_file=/etc/ssl/private/vsftpd.pem" >> /etc/vsftpd.conf
sed -i " " /etc/vsftpd.conf
elif grep 'rsa_private_key_file=/etc/ssl/private/vsftpd.pem' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: rsa_private_key_file=/etc/ssl/private/vsftpd.pem este deja configurat."
else
echo "Eroare: Configurare rsa_private_key_file=/etc/ssl/private/vsftpd.pem esuata."
fi

if ! grep 'ssl_enable=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
sed -i "s|ssl_enable=NO|ssl_enable=YES|g" /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf
elif grep 'ssl_enable=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: ssl_enable=NO este deja configurat."
else
echo "Eroare: Configurare ssl_enable=NO esuata."
fi

if ! grep 'ssl_tlsv1=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "ssl_tlsv1=YES" >> /etc/vsftpd.conf
elif grep 'ssl_tlsv1=YES' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: ssl_tlsv1=YES este deja configurat."
else
echo "Eroare: Configurare ssl_tlsv1=YES esuata."
fi

if ! grep 'ssl_sslv2=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "ssl_sslv2=NO" >> /etc/vsftpd.conf
elif grep 'ssl_sslv2=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: ssl_sslv2=NO este deja configurat."
else
echo "Eroare: Configurare ssl_sslv2=NO esuata."
fi

if ! grep 'ssl_sslv3=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "ssl_sslv3=NO" >> /etc/vsftpd.conf
elif grep 'ssl_sslv3=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: ssl_sslv3=NO este deja configurat."
else
echo "Eroare: Configurare ssl_sslv3=NO esuata."
fi

if ! grep 'require_ssl_reuse=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "require_ssl_reuse=NO" >> /etc/vsftpd.conf
elif grep 'require_ssl_reuse=NO' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: require_ssl_reuse=NO este deja configurat."
else
echo "Eroare: Configurare require_ssl_reuse=NO esuata."
fi

if ! grep 'ssl_ciphers=HIGH' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "ssl_ciphers=HIGH" >> /etc/vsftpd.conf
elif grep 'ssl_ciphers=HIGH' /etc/vsftpd.conf >/dev/null 2>&1; then
echo "vsFTPD: ssl_ciphers=HIGH este deja configurat"
else
echo "Eroare: Configurare ssl_ciphers=HIGH esuata."
fi

sudo systemctl restart vsftpd

sftprandom=$(openssl rand -hex 6)
sftpuser="user-"$sftprandom
sftppass=$(openssl rand -base64 16)
if ! id $sftpuser >/dev/null 2>&1; then
sudo adduser $sftpuser --gecos "First Last,RoolNumber,WorkPhone,HomePhone" --disabled-password
echo "$sftpuser:$sftppass" | sudo chpasswd

line="* * * * * sudo chown -R $sftpuser:$sftpuser /home/$sftpuser/ftp/server\n* * * * * ( sleep 30 ; sudo chown -R $sftpuser:$sftpuser /home/$sftpuser/ftp/server )"
(crontab -u $sftpuser -l; echo "$line") | crontab -u $sftpuser -

sudo mkdir /home/$sftpuser/ftp
sudo chown nobody:nogroup /home/$sftpuser/ftp
sudo chmod a-w /home/$sftpuser/ftp
sudo mkdir /home/$sftpuser/ftp/server
sudo chown $sftpuser:$sftpuser /home/$sftpuser/ftp/server

echo "$sftpuser  ALL=NOPASSWD: ALL" >> /etc/sudoers
echo "$sftpuser" >> /etc/vsftpd.userlist
fi

if ! dpkg --get-selections | grep default-jdk; then
sudo apt-get install -y default-jdk
elif dpkg --get-selections | grep default-jdk; then
echo "Java este deja configurat."
else
echo "Eroare configurare Java."
fi

if ! dpkg --get-selections | grep mysql >/dev/null 2>&1; then
export DEBIAN_FRONTEND=noninteractive
mysqlrootpass=$(openssl rand -base64 32)
MYSQL_ROOT_PASSWORD="$mysqlrootpass"

echo debconf mysql-server/root_password password $MYSQL_ROOT_PASSWORD | sudo debconf-set-selections
echo debconf mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD | sudo debconf-set-selections

sudo apt-get -qq install mysql-server > /dev/null # Install MySQL quietly


sudo apt-get -qq install expect > /dev/null


tee ~/secure_our_mysql.sh > /dev/null << EOF
spawn $(which mysql_secure_installation)

expect "Enter password for user root:"
send "$MYSQL_ROOT_PASSWORD\r"

expect "Press y|Y for Yes, any other key for No:"
send "y\r"

expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:"
send "0\r"

expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
send "n\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send "y\r"

EOF

sudo expect ~/secure_our_mysql.sh

rm -v ~/secure_our_mysql.sh
sudo apt-get -qq purge expect > /dev/null ct

elif dpkg --get-selections | grep mysql >/dev/null 2>&1; then
echo "MySQL: MySQL este deja configurat."
else
echo "MySQL: Eroare configuare MYSQL."
fi

if ! dpkg --get-selections | grep phpmyadmin >/dev/null 2>&1; then
echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
apt-get install -y phpmyadmin
elif dpkg --get-selections | grep phpmyadmin >/dev/null 2>&1; then
echo "PhpMyAdmin: Phpmyadmin este deja configurat."
else
echo "PhpMyAdmin: Eroare configurare Phpmyadmin."
fi
if ! grep 'Include /etc/phpmyadmin/apache.conf' /etc/apache2/apache2.conf >/dev/null 2>&1; then
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
elif grep 'Include /etc/phpmyadmin/apache.conf' /etc/apache2/apache2.conf >/dev/null 2>&1; then
echo "PhpMyAdmin: Fisierul Apache este deja configurat."
else
echo "PhpMyAdmin: Eroare configurare fisier Apache."
fi

if [ ! -f "/etc/apache2/ssl/apache.key" ]; then
mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -subj "/C=RO/ST=.../L=Stockholm /O=.../OU=.../CN=fishy.ro/emailAddress=..."
elif [ -f "/etc/apache2/ssl/apache.key" ]; then
echo "SSL: Certificatul exista deja."
else
echo "SSL: Eroare la crearea certificatului SSL."
fi

if ! grep 'SSLEngine' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
var='SSLEngine on\nSSLCertificateFile /etc/apache2/ssl/apache.crt\nSSLCertificateKeyFile /etc/apache2/ssl/apache.key'
sed -i "/ServerAdmin/a\\$var" /etc/apache2/sites-available/000-default.conf
a2enmod ssl
service apache2 restart
elif grep 'SSLEngine' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
echo "SSL: Fisierul a fost deja configurat."
else
echo "SSL: Eroare configurare SSLEngine."
fi

if ! grep '*:443' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
sed -i "s|*:80|*:443|g" /etc/apache2/sites-available/000-default.conf
elif grep '*:443' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
echo "SSL: Portul 443 a fost deja configurat."
else
echo "SSL: Eroare schimbare port 443."
fi

if ! grep '*:80>' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
ip=$(hostname -i)
text="<VirtualHost *:80>\n\n</VirtualHost>"
sed -i "1 i\\$text" /etc/apache2/sites-available/000-default.conf
elif grep '*:80>' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
echo "SSL: Portul 80 a fost deja configurat."
else "SSL: Eroare adaugare VirtualHost pentru redirectionare port 80."
fi

if ! grep 'ForceSSL' /etc/phpmyadmin/config.inc.php >/dev/null 2>&1; then
cat >> /etc/phpmyadmin/config.inc.php <<EOF

\$cfg['ForceSSL'] = true;
EOF
elif grep 'ForceSSL' /etc/phpmyadmin/config.inc.php >/dev/null 2>&1; then
echo "SSL: Phpmyadmin a fost deja configurat."
else
echo "SSL: Eroare configurare ForceSSL Phpmyadmin."
fi
service apache2 restart

if ! grep 'AuthType Basic' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
cat >> /etc/apache2/sites-available/000-default.conf <<EOF

<Directory /usr/share/phpmyadmin>
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user
</Directory>
EOF

elif grep 'AuthType Basic' /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
echo "SECURE: Fisierul a fost deja configurat."
else
echo "SECURE: Eroare configurare fisier."
fi
service apache2 restart

if [ ! -s /etc/apache2/.htpasswd ]; then
apacherandom=$(openssl rand -base64 8)
apacheuser="apache-"$apacherandom;
apachepass=$(openssl rand -base64 16)
htpasswd -b -c /etc/apache2/.htpasswd $apacheuser $apachepass
chmod 640 /etc/apache2/.htpasswd
chgrp www-data /etc/apache2/.htpasswd
elif [ -s /etc/apache2/.htpasswd ]; then
echo "SECURE: Parola a fost deja configurata."
else
echo "SECURE: Eroare configurare parola."
fi

if ! grep 'ServerSignature Off' /etc/apache2/apache2.conf; then
echo 'ServerSignature Off' >> /etc/apache2/apache2.conf
echo ' ' >> /etc/apache2/apache2.conf
elif grep 'ServerSignature Off' /etc/apache2/apache2.conf; then
echo "SECURE: ServerSignature Off este deja configurat."
else
echo "Eroare: Configurare ServerSignature Off esuata."
fi

if ! grep 'ServerTokens Prod' /etc/apache2/apache2.conf; then
echo 'ServerTokens Prod' >> /etc/apache2/apache2.conf
echo ' ' >> /etc/apache2/apache2.conf
elif grep 'ServerTokens Prod' /etc/apache2/apache2.conf; then
echo "SECURE: ServerTokens Prod este deja configurat."
else
echo "Eroare: Configurare ServerTokens Prod esuata."
fi

service apache2 restart

if grep 'Alias /phpmyadmin /usr/share/phpmyadmin' /etc/phpmyadmin/apache.conf; then
url=$(openssl rand -base64 32)
string="Alias /phpmyadmin /usr/share/phpmyadmin"
replace="Alias /$url /usr/share/phpmyadmin"
ip=$(hostname -i)
sed -i "s|$string|$replace|g" /etc/phpmyadmin/apache.conf
elif ! grep 'Alias /phpmyadmin /usr/share/phpmyadmin' /etc/phpmyadmin/apache.conf; then
echo "URL: URL-ul a fost deja configurat."
else
echo "URL: Eroare configurare URL."
fi
if ! grep 'Require all granted' /etc/phpmyadmin/apache.conf >/dev/null 2>&1; then
var="<RequireAny>\nRequire all granted\n</RequireAny>"
sed -i "/IfModule mod_authz_core.c/a\\$var" /etc/phpmyadmin/apache.conf
elif grep 'Require all granted' /etc/phpmyadmin/apache.conf >/dev/null 2>&1; then
echo "URL: Fisierul Phpmyadmin este deja configurat."
else
echo "URL: Eroare configurare fisier Phpmyadmin."
fi

if grep "upload_max_filesize = 2M" /etc/php/7.*/apache2/php.ini >/dev/null 2>&1; then
string="upload_max_filesize = 2M"
replace="upload_max_filesize = 102M"
sed -i "s|$string|$replace|g" /etc/php/7.*/apache2/php.ini
fi

if grep "post_max_size = 8M" /etc/php/7.*/apache2/php.ini >/dev/null 2>&1; then
string="post_max_size = 8M"
replace="post_max_size = 108M"
sed -i "s|$string|$replace|g" /etc/php/7.*/apache2/php.ini
fi

service apache2 restart
if [ ! -d "/etc/fail2ban/" ]; then
apt-get install -y fail2ban
elif [ -d "/etc/fail2ban/" ]; then
echo "Fail2ban: Fail2ban este deja instalat."
else
echo "Fail2ban: Eroare instalare Fail2ban."
fi

if [ ! -s "/etc/fail2ban/jail.local" ] >/dev/null 2>&1; then
touch /etc/fail2ban/jail.local
cat >> /etc/fail2ban/jail.local <<EOM
##To block failed login attempts use the below jail.
 [apache]
 enabled = true
 port = http,https
 filter = apache-auth
 logpath = /var/log/apache2/*error.log
 maxretry = 22
 bantime = 604600

 ##To block the remote host that is trying to request suspicious URLs, use the below jail.
 [apache-overflows]
 enabled = true
 port = http,https
 filter = apache-overflows
 logpath = /var/log/apache2/*error.log
 maxretry = 22
 bantime = 604600

 ##To block the remote host that is trying to search for scripts on the website to execute, use the below jail.
 [apache-noscript]
 enabled = true
 port = http,https
 filter = apache-noscript
 logpath = /var/log/apache2/*error.log
 maxretry = 22
 bantime = 604600

 ##To block the remote host that is trying to request malicious bot, use below jail.
 [apache-badbots]
 enabled = true
 port = http,https
 filter = apache-badbots
 logpath = /var/log/apache2/*error.log
 maxretry = 22
 bantime = 604600

 ##To block the failed login attempts on the SSH server, use the below jail.
 [ssh]
 enabled = true
 port = $newport
 filter = sshd
 logpath = /var/log/auth.log
 maxretry = 22
 bantime = 604600

 [vsftpd]
enabled  = true
filter   = vsftpd
action   = iptables[name=VSFTPD, port=ftp, protocol=tcp]
logpath  = /var/log/vsftpd.log
# "maxretry" is the number of failures before a host get banned.
maxretry = 22
bantime  = 604600
EOM

elif [ -s "/etc/fail2ban/jail.local" ] >/dev/null 2>&1; then
echo "Fail2ban: jail.local a fost deja configurat."
else
echo "Fail2ban: Eroare configurare jail.local."
fi

sudo sed -i '613s/] == 1)/]) == 1)/' /usr/share/phpmyadmin/libraries/sql.lib.php

sudo sed -i '614s/)))/))/' /usr/share/phpmyadmin/libraries/sql.lib.php

sudo service mysql reload -y

sudo service apache2 reload -y

sudo timedatectl set-timezone Europe/Bucharest

service fail2ban restart -y

if ! dpkg --get-selections | grep ufw >/dev/null 2>&1; then
apt-get install -y ufw
yes | sudo ufw enable -y
sshport=$(grep -oP "#Port\s+\K\w+" /etc/ssh/sshd_config)
sudo ufw allow http
sudo ufw allow https
sudo ufw allow mail
sudo ufw allow $sshport
sudo ufw allow 20/tcp
sudo ufw allow 21
sudo ufw allow 7777
sudo ufw allow 990/tcp
sudo ufw allow 40000:50000/tcp
sudo ufw allow 22003
sudo ufw allow 22005
sudo ufw allow 22015
sudo ufw allow 9987
sudo ufw allow 25565
sudo ufw allow 9987
sudo ufw allow 10011
sudo ufw allow 30033
sudo ufw allow 27020
sudo ufw allow 27005
sudo ufw allow 22126
elif dpkg --get-selections | grep ufw >/dev/null 2>&1; then
sudo ufw enable -y
sshport=$(grep -oP "Port\s+\K\w+" /etc/ssh/sshd_config)
sudo ufw allow http
sudo ufw allow https
sudo ufw allow mail
sudo ufw allow $sshport
sudo ufw allow 20/tcp
sudo ufw allow 21
sudo ufw allow 7777
sudo ufw allow 990/tcp
sudo ufw allow 40000:50000/tcp
sudo ufw allow 22003
sudo ufw allow 22005
sudo ufw allow 22015
sudo ufw allow 9987
sudo ufw allow 25565
sudo ufw allow 30120
sudo ufw allow 9987
sudo ufw allow 10011
sudo ufw allow 30033
sudo ufw allow 27020
sudo ufw allow 27005
sudo ufw allow 22126
else
echo "UFW: Eroare configurare UFW."
fi

yes | sudo dpkg --add-architecture i386; yes | sudo apt-get install -y mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc tmux lib32gcc1 libstdc++6 libstdc++6:i386
if [ ! -d /home/$sftpuser/ftp/server/LinuxGSM ]; then
apt-get install -y git
apt-get install -y curl
cd /home/$sftpuser/ftp/server
git clone https://github.com/GameServerManagers/LinuxGSM.git
chmod 755 /home/$sftpuser/ftp/server/LinuxGSM/lgsm/functions/*
chown -R $sftpuser:$sftpuser /home/$sftpuser/ftp/server/LinuxGSM
elif [ -d /home/$sftpuser/ftp/server/LinuxGSM ]; then
echo "LinuxGSM: LinuxGSM este deja configurat."
else
echo "Eroare configurare LinuxGSM."
fi

if [ ! -f /home/$sftpuser/gdrive.sh ]; then
cd /home/$sftpuser

elif [ -f /home/$sftpuser/install.sh ]; then
echo "Google Drive: Fisierul gdrive.sh a fost deja configurat."
else
echo "Eroare: configurare Google Drive esuata."
fi

if [ ! -f /home/$sftpuser/install.sh ]; then
cd /home/$sftpuser

cat>> install.sh <<EOM
#!/bin/bash
user=\$(whoami)
cd /home/\$user/ftp/server/LinuxGSM
./linuxgsm.sh \$1

cd /home/\$user/ftp/server/LinuxGSM >/dev/null 2>&1
newfile=\$(ls -1 -t | head -1) >/dev/null 2>&1
mkdir /home/\$user/ftp/server/\$newfile >/dev/null 2>&1
cp \$newfile /home/\$user/ftp/server/\$newfile >/dev/null 2>&1

cd /home/\$user >/dev/null 2>&1
file=\$newfile
if [[ \$file = "csgoserver"* ]]; then
echo "#!/bin/bash
me=\\\`basename \"\\\$0\"\\\`
ip=\\\$(hostname -i)
user=\\\$(whoami)

if [[ \\\$1 = \"fastdl\" ]] || [[ \\\$1 = \"fd\" ]]; then
if ! grep \\\"sv_downloadurl \\\"http://\\\$ip/\\\$me/fastdl\\\"\\\" ~/ftp/server/\\\$me/serverfiles/csgo/cfg/csgoserver.cfg >/dev/null 2>&1; then
echo " " >> ~/ftp/server/\\\$me/serverfiles/csgo/cfg/csgoserver.cfg
echo \\\"sv_downloadurl \"http://\\\$ip/\\\$me/fastdl\"\\\" >> ~/ftp/server/\\\$me/serverfiles/csgo/cfg/csgoserver.cfg
fi
if ! grep \\\"sv_allowdownload 0\\\" ~/ftp/server/\\\$me/serverfiles/csgo/cfg/csgoserver.cfg >/dev/null 2>&1; then
echo \\\"sv_allowdownload 0\\\" >> ~/ftp/server/\\\$me/serverfiles/csgo/cfg/csgoserver.cfg
fi
if ! grep \"DocumentRoot /home/\\\$user/ftp/server/public_html\" /etc/apache2/sites-available/000-default.conf >/dev/null 2>&1; then
file=\"ServerName localhost \\\
        \\\nServerAlias localhost \\\
        \\\nDocumentRoot /home/\\\$user/ftp/server/public_html \\\
        \\\n<Directory /home/\\\$user/ftp/server/public_html> \\\
                \\\nOptions Indexes FollowSymLinks MultiViews \\\
                \\\nAllowOverride All \\\
                \\\nRequire all granted \\\
        \\\n</Directory> \\\
        \\\nErrorLog \\\${APACHE_LOG_DIR}/error.log \\\
        \\\nLogLevel warn \\\
        \\\nCustomLog \\\${APACHE_LOG_DIR}/access.log combined\"
sudo sed -i \"/80/a\\\$file\" /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart
fi
if [ ! -d ~/ftp/server/public_html/\\\$me/fastdl ]; then
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
cd ~/ftp/server/\\\$me
yes | ./\\\$me \\\$1
mkdir -p ~/ftp/server/public_html/\\\$me/fastdl
mv ~/ftp/server/\\\$me/public_html/fastdl/* ~/ftp/server/public_html/\\\$me/fastdl
rm -rf ~/ftp/server/\\\$me/public_html
cd ~/ftp/server/public_html/\\\$me
chmod -R 777 *
echo \"Puteti accesa linkul la adresa: http://\\\$ip/\\\$me/fastdl/\"
else \"Serverul \\\$me nu este instalat. Pentru a instala acest server folositi comanda ./\\\$me install.\"
fi
elif [ -d ~/ftp/server/public_html/\\\$me/fastdl ]; then
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
cd ~/ftp/server/public_html/\\\$me/fastdl
rm -rf *
cd ~/ftp/server/\\\$me
yes | ./\\\$me \\\$1
mv ~/ftp/server/\\\$me/public_html/fastdl/* ~/ftp/server/public_html/\\\$me/fastdl
rm -rf ~/ftp/server/\\\$me/public_html
cd ~/ftp/server/public_html/\\\$me
chmod -R 777 *
echo \"Puteti accesa linkul la adresa: http://\\\$ip/\\\$me/fastdl/\"
else
echo \"Serverul \\\$me nu este instalat. Pentru a instala acest server folositi comanda ./\\\$me install.\"
fi
if [ ! -f ~/ftp/server/public_html/index.php ]; then
cd ~/ftp/server/public_html
echo \"<!doctype html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, shrink-to-fit=no\">
    <meta name=\"description\" content=\"\">
    <meta name=\"author\" content=\"\">

    <title>Fishy Hosting</title>

    <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css\" integrity=\"sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm\" crossorigin=\"anonymous\">

  <style>
  /*
 * Globals
 */

/* Links */
a,
a:focus,
a:hover {
  color: #fff;
}

/* Custom default button */
.btn-secondary,
.btn-secondary:hover,
.btn-secondary:focus {
  color: #333;
  text-shadow: none; /* Prevent inheritance from `body` */
  background-color: #fff;
  border: .05rem solid #fff;
}


/*
 * Base structure
 */

html,
body {
  height: 100%;
  background-color: #333;
}

body {
  display: -ms-flexbox;
  display: -webkit-box;
  display: flex;
  -ms-flex-pack: center;
  -webkit-box-pack: center;
  justify-content: center;
  color: #fff;
  text-shadow: 0 .05rem .1rem rgba(0, 0, 0, .5);
  box-shadow: inset 0 0 5rem rgba(0, 0, 0, .5);
}

.cover-container {
  max-width: 42em;
}


/*
 * Header
 */
.masthead {
  margin-bottom: 2rem;
}

.masthead-brand {
  margin-bottom: 0;
}

.nav-masthead .nav-link {
  padding: .25rem 0;
  font-weight: 700;
  color: rgba(255, 255, 255, .5);
  background-color: transparent;
  border-bottom: .25rem solid transparent;
}

.nav-masthead .nav-link:hover,
.nav-masthead .nav-link:focus {
  border-bottom-color: rgba(255, 255, 255, .25);
}

.nav-masthead .nav-link + .nav-link {
  margin-left: 1rem;
}

.nav-masthead .active {
  color: #fff;
  border-bottom-color: #fff;
}

@media (min-width: 48em) {
  .masthead-brand {
    float: left;
  }
  .nav-masthead {
    float: right;
  }
}


/*
 * Cover
 */
.cover {
  padding: 0 1.5rem;
}
.cover .btn-lg {
  padding: .75rem 1.25rem;
  font-weight: 700;
}


/*
 * Footer
 */
.mastfoot {
  color: rgba(255, 255, 255, .5);
}
  </style>
  </head>

<body class=\"text-center\">

    <div class=\"cover-container d-flex h-100 p-3 mx-auto flex-column\">
      <header class=\"masthead mb-auto\">
        <div class=\"inner\">
          <nav class=\"nav nav-masthead justify-content-center\">
          </nav>
        </div>
      </header>

      <main role=\"main\" class=\"inner cover\">
        <h1 class=\"cover-heading\">Bine ai venit</h1>
        <p class=\"lead\">Din nefericire aceasta nu este pagina pe care o cauti.</p>
        <p class=\"lead\">
        </p>
      </main>

      <footer class=\"mastfoot mt-auto\">
        <div class=\"inner\">
          <p>Gazduit de <a href=\"https://fishy.ro\">Fishy Hosting</a>.</p>
        </div>
      </footer>
    </div>

<script src=\"https://code.jquery.com/jquery-3.2.1.slim.min.js\" integrity=\"sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN\" crossorigin=\"anonymous\"></script>
<script src=\"https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js\" integrity=\"sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q\" crossorigin=\"anonymous\"></script>
<script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js\" integrity=\"sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl\" crossorigin=\"anonymous\"></script>

</body>
</html>\" >> index.php
fi
fi
elif [[ \\\$1 = \"delete\" ]]; then
read -r -p \"Esti sigur ca vrei sa stergi acest server? [Da/Nu]\" response
if [[ \"\\\$response\" =~ ^([dD][aA])+\\\$ ]]; then
count=0
if [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
((count++))
fi
if [ -d ~/ftp/server/public_html/\\\$me ]; then
rm -rf ~/ftp/server/public_html/\\\$me
((count++))
else
((count++))
fi
if [ -f ~/ftp/server/LinuxGSM/\\\$me ];then
rm ~/ftp/server/LinuxGSM/\\\$me
((count++))
fi
if [ -f \\\$me ]; then
rm \\\$me
((count++))
fi
if [ \"\\\$count\" -eq \"4\" ]; then
echo \"Stergerea serverul a fost efecuata cu succes!\"
else
echo \"Eroare la stergerea serverului: nu toate fisierele au fost sterse.\"
fi
elif [[ \"\\\$response\" =~ ^([nN][uU])+\\\$ ]]; then
echo \"Operatiunea a fost oprita.\"
else
echo \"Ati introdus o comanda invalida. Operatiunea a fost anulata.\"
fi
else
cd ~/ftp/server/\\\$me
./\\\$me \\\$1
fi" > \$file
elif [[ \$file = "mcserver"* ]]; then
echo "#!/bin/bash
me=\\\`basename \"\\\$0\"\\\`
ip=\\\$(hostname -i)
user=\\\$(whoami)
if [[ \\\$1 = \"delete\" ]]; then
read -r -p \"Esti sigur ca vrei sa stergi acest server? [Da/Nu]: \" response
response=\\\$(echo \"\\\$response\" | tr '[:upper:]' '[:lower:]')
if [ \"\\\$response\" = \"da\" ]; then
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
count=0
if [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
((count++))
fi
if [ -d ~/ftp/server/public_html/\\\$me ]; then
rm -rf ~/ftp/server/public_html/\\\$me
((count++))
else
((count++))
fi
if [ -f ~/ftp/server/LinuxGSM/\\\$me ];then
rm ~/ftp/server/LinuxGSM/\\\$me
((count++))
fi
if [ -f \\\$me ]; then
rm \\\$me
((count++))
fi
if [ \"\\\$count\" -eq \"4\" ]; then
echo \"Stergerea serverul a fost efecuata cu succes!\"
else
echo \"Eroare la stergerea serverului: nu toate fisierele au fost sterse.\"
fi
elif [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
rm ~/ftp/server/LinuxGSM/\\\$me
rm \\\$me
echo \"Serverul a fost sters cu succes.\"
else
echo \"Serverul nu este instalat. Operatiune anulata.\"
fi
elif [ \"\\\$response\" = \"nu\" ]; then
echo \"Operatiunea a fost oprita.\"
else
echo \"Ati introdus o comanda invalida. Operatiunea a fost anulata.\"
fi
elif [ \\\$1 = \"buildtools\" ]; then
if [ ! -f ~/ftp/server/\\\$me/serverfiles/BuildTools.jar ]; then
read -r -p \"Toate fisierele serverului vor fi sterse iar BuildTools va fi reinstalat. Vrei sa faci asta? [Da/Nu]: \" response
response=\\\$(echo \"\\\$response\" | tr '[:upper:]' '[:lower:]')
if [ \"\\\$response\" = \"da\" ]; then
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
cd ~/ftp/server/\\\$me/serverfiles
rm -rf *
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
echo "Folositi din nou comanda ./\\\$me buildtools si urmati instructiunile."
else
echo \"Serverul nu este instalat. Operatiune anulata.\"
fi
elif [ \"\\\$response\" = \"nu\" ]; then
echo \"Operatiune a fost anulata.\"
else
echo \"Nu ati introdus o comanda valida. Operatiune anulata.\"
fi
else

buildtools() {
mc=\"\"
ver=\"\\\$1\"
select opt in \"Spigot\" \"Bukkit\" ; do
                if (( REPLY == 1 )) ; then
                mc=\"spigot\"
                break
                elif (( REPLY == 2 )) ; then
                mc=\"bukkit\"
                break
                fi
        done
        cd ~/ftp/server/\\\$me/serverfiles
        if [ -f craftbukkit* ]; then
                rm craftbukkit*
        fi
        if [ -f spigot* ]; then
                rm spigot*
        fi

        find . -type f -name '*.o' -exec rm {} +
        java -jar BuildTools.jar --rev \\\$ver

        if [ \"\\\$mc\" = \"spigot\" ]; then
                cd ~/ftp/server/\\\$me/serverfiles
                if [ -f minecraft_server.jar ]; then
                rm minecraft_server.jar
                fi
                rm craftbukkit*
                touch versiune_curenta_spigot-\\\$ver.o
                mv spigot* minecraft_server.jar
        elif [ \"\\\$mc\" = \"bukkit\" ]; then
                cd ~/ftp/server/\\\$me/serverfiles
                if [ -f minecraft_server.jar ]; then
                rm minecraft_server.jar
                fi
                rm spigot*
                touch versiune_curenta_craftbukkit-\\\$ver.o
                mv craftbukkit* minecraft_server.jar
        fi
}

select opt in \"1.12.2\" \"1.12.1\" \"1.12\" \"1.11\" \"1.10\" \"1.9.4\" \"1.9.2\" \"1.9\" \"1.8.8\" \"1.8.7\" \"1.8.3\" \"1.8\"; do
   if (( REPLY == 1 )) ; then
        buildtools 1.12.2
        exit
   elif (( REPLY == 2 )) ; then
        buildtools 1.12.1
        exit
   elif (( REPLY == 3 )) ; then
        buildtools 1.12
        exit
   elif (( REPLY == 4 )) ; then
        buildtools 1.11
        exit
   elif (( REPLY == 5 )) ; then
        buildtools 1.10
        exit
   elif (( REPLY == 6 )) ; then
        buildtools 1.9.4
        exit
   elif (( REPLY == 7 )) ; then
        buildtools 1.9.2
        exit
   elif (( REPLY == 8 )) ; then
        buildtools 1.9
        exit
   elif (( REPLY == 9 )) ; then
        buildtools 1.8.8
        exit
   elif (( REPLY == 10 )) ; then
        buildtools 1.8.7
        exit
   elif (( REPLY == 11 )) ; then
        buildtools 1.8.3
        exit
   elif (( REPLY == 12 )) ; then
        buildtools 1.8
        exit
   else
        echo \"Optiune invalida.\"
   fi
done
fi
elif [ \"\\\$1\" = \"start\" ]; then
if ! grep \"server-ip=\\\$ip\" ~/ftp/server/\\\$me/serverfiles/server.properties >/dev/null 2>&1; then
string=\"server-ip=\"
replace=\"server-ip=\\\$ip\"
sed -i \"s|\\\$string|\\\$replace|g\" ~/ftp/server/\\\$me/serverfiles/server.properties
fi
if grep \"online-mode=true\" ~/ftp/server/\\\$me/serverfiles/server.properties >/dev/null 2>&1; then
string=\"online-mode=true\"
replace=\"online-mode=false\"
sed -i \"s|\\\$string|\\\$replace|g\" ~/ftp/server/\\\$me/serverfiles/server.properties
fi
if grep \"eula=false\" ~/ftp/server/\\\$me/serverfiles/eula.txt >/dev/null 2>&1; then
string=\"eula=false\"
replace=\"eula=true\"
sed -i \"s|\\\$string|\\\$replace|g\" ~/ftp/server/\\\$me/serverfiles/eula.txt
fi
cd ~/ftp/server/\\\$me
./\\\$me \\\$1
elif [ \\\$1 = \"install\" ]; then
read -r -p \"Toate fisierele serverului vor fi sterse iar serverul de baza (Minecraft) va fi reinstalat. Vrei sa faci asta? [Da/Nu]: \" response
response=\\\$(echo \"\\\$response\" | tr '[:upper:]' '[:lower:]')
if [ \"\\\$response\" = \"da\"]; then
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
cd ~/ftp/server/\\\$me/serverfiles
rm -rf *
cd ~/ftp/server/\\\$me
./\\\$me \\\$1
else
echo \"Serverul nu este instalat. Operatiune anulata.\"
fi
elif [ \"\\\$response\" = \"nu\"]; then
echo \"Operatiune a fost anulata.\"
else
echo \"Nu ati introdus o comanda valida. Operatiune anulata.\"
fi
else
cd ~/ftp/server/\\\$me
./\\\$me \\\$1
fi" > \$file
elif [[ \$file = "mtaserver"* ]]; then
echo "#!/bin/bash
me=\\\`basename \"\\\$0\"\\\`
ip=\\\$(hostname -i)
user=\\\$(whoami)
if [[ \\\$1 = \"delete\" ]]; then
read -r -p \"Esti sigur ca vrei sa stergi acest server? [Da/Nu]: \" response
response=\\\$(echo \"\\\$response\" | tr '[:upper:]' '[:lower:]')
if [ \"\\\$response\" = \"da\" ]; then
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
count=0
if [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
((count++))
fi
if [ -d ~/ftp/server/public_html/\\\$me ]; then
rm -rf ~/ftp/server/public_html/\\\$me
((count++))
else
((count++))
fi
if [ -f ~/ftp/server/LinuxGSM/\\\$me ];then
rm ~/ftp/server/LinuxGSM/\\\$me
((count++))
fi
if [ -f \\\$me ]; then
rm \\\$me
((count++))
fi
if [ \"\\\$count\" -eq \"4\" ]; then
echo \"Stergerea serverul a fost efecuata cu succes!\"
else
echo \"Eroare la stergerea serverului: nu toate fisierele au fost sterse.\"
fi
elif [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
rm ~/ftp/server/LinuxGSM/\\\$me
rm \\\$me
echo \"Serverul a fost sters cu succes.\"
else
echo \"Serverul nu este instalat. Operatiune anulata.\"
fi
elif [ \"\\\$response\" = \"nu\" ]; then
echo \"Operatiunea a fost oprita.\"
else
echo \"Ati introdus o comanda invalida. Operatiunea a fost anulata.\"
fi
elif [ \"\\\$1\" = \"install\" ]; then
cd ~/ftp/server/\\\$me
./\\\$me install
if [ ! -d ~/ftp/server/\\\$me/serverfiles/x64/modules ]; then
sudo mkdir -p ~/ftp/server/\\\$me/serverfiles/x64/modules
cd ~/ftp/server/\\\$me/serverfiles/x64/modules
sudo wget https://nightly.mtasa.com/files/modules/64/mta_mysql.so
fi
elif [ \"\\\$1\" = \"ai\" ]; then
cd ~/ftp/server/\\\$me
./\\\$me ai
if [ ! -d ~/ftp/server/\\\$me/serverfiles/x64/modules ]; then
sudo mkdir -p ~/ftp/server/\\\$me/serverfiles/x64/modules
cd ~/ftp/server/\\\$me/serverfiles/x64/modules
sudo wget https://nightly.mtasa.com/files/modules/64/mta_mysql.so
fi
else
cd ~/ftp/server/\\\$me
./\\\$me \\\$1
fi" > \$file
else
echo "#!/bin/bash
me=\\\`basename \"\\\$0\"\\\`
ip=\\\$(hostname -i)
user=\\\$(whoami)
if [[ \\\$1 = \"delete\" ]]; then
read -r -p \"Esti sigur ca vrei sa stergi acest server? [Da/Nu]\" response
response=\\\$(echo \"\\\$response\" | tr \'[:upper:]\' \'[:lower:]\')
if [ \"\\\$response\" = \"da\"]; then
count=0
if [ -d ~/ftp/server/\\\$me/serverfiles ]; then
if [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
((count++))
fi
if [ -d ~/ftp/server/public_html/\\\$me ]; then
rm -rf ~/ftp/server/public_html/\\\$me
((count++))
else
((count++))
fi
if [ -f ~/ftp/server/LinuxGSM/\\\$me ];then
rm ~/ftp/server/LinuxGSM/\\\$me
((count++))
fi
if [ -f \\\$me ]; then
rm \\\$me
((count++))
fi
if [ \"\\\$count\" -eq \"4\" ]; then
echo \"Stergerea serverul a fost efecuata cu succes!\"
else
echo \"Eroare la stergerea serverului: nu toate fisierele au fost sterse.\"
fi
elif [ -d ~/ftp/server/\\\$me ]; then
rm -rf ~/ftp/server/\\\$me
rm ~/ftp/server/LinuxGSM/\\\$me
rm \\\$me
echo \"Serverul a fost sters cu succes.\"
else
echo \"Serverul nu este instalat. Operatiune anulata.\"
fi
elif [ \"\\\$response\" = \"nu\" ]; then
echo \"Operatiunea a fost oprita.\"
else
echo \"Ati introdus o comanda invalida. Operatiunea a fost anulata.\"
fi
else
cd ~/ftp/server/LinuxGSM
./\\\$me \\\$1
fi" > \$file
fi
chmod 777 \$file
EOM
chmod 777 install.sh
elif [ -f /home/$sftpuser/install.sh ]; then
echo "LinuxGSM: LinuxGSM este deja configurat."
else
echo "Eroare configurare LinuxGSM."
fi

apt-get install -y nano

if [ ! -f "date_vps.txt" ] >/dev/null 2>&1; then
cat >> date_vps.txt <<EOM
Buna ziua.

Va multumim ca ati ales serviciile noastre si va dorim succes cu toate proiectele pe care le aveti.

Mai jos aveti toate datele necesare.


***FOARTE IMPORTANT***
Cand intrati pelinkul PhpMyAdmin va trebui sa puneti un user si o parola. Atentie!
Acestea sunt diferite fata de userul si parola PhpMyAdmin si trebuie folosite din motive de securitate.

User: $apacheuser
Parola: $apachepass

PhpMyAdmin:
(Nu va panicati la aparitia erorii legate de certificat. Continuati la pagina.)

PhpMyAdmin: https://$ip/$url
User: root
Parola: $mysqlrootpass

FileZilla:
(Alegeti protocolul FTP, iar la Encryption alegeti 'Require explicit FTP over TLS'.)

Hostname: $ip
User: $sftpuser
Parola: $sftppass

Putty:

Hostname: $ip
User: $sftpuser
Parola: $sftppass
Port: $sshport

Instructiuni:

Intrati pe https://wiki.fishy.ro

Aici aveti toate tutorialele de care aveti nevoie.
EOM

elif [ -f "date_vps.txt" ] >/dev/null 2>&1; then
echo "Detaliile configurarii initiale au fost deja transmise."
else
echo "Eroare trimitere detalii configurare initiala."
fi

sudo mv date_vps.txt ftp/server/

if [ ! -f "email.txt" ] >/dev/null 2>&1; then
cat >> email.txt <<EOM
<!doctype html>
<html style="width:100%;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;">
 <head> 
  <meta charset="UTF-8"> 
  <meta content="width=device-width, initial-scale=1" name="viewport"> 
  <meta name="x-apple-disable-message-reformatting"> 
  <meta http-equiv="X-UA-Compatible" content="IE=edge"> 
  <meta content="telephone=no" name="format-detection"> 
  <title>Date VPS</title> 
  <!--[if (mso 16)]>
    <style type="text/css">
    a {text-decoration: none;}
    </style>
    <![endif]--> 
  <!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]--> 
  <!--[if !mso]><!-- --> 
  <link href="https://fonts.googleapis.com/css?family=Roboto:400,400i,700,700i" rel="stylesheet"> 
  <!--<![endif]--> 
  <style type="text/css">
@media only screen and (max-width:600px) {.st-br { padding-left:10px!important; padding-right:10px!important } p, ul li, ol li, a { font-size:16px!important; line-height:150%!important } h1 { font-size:30px!important; text-align:center; line-height:120%!important } h2 { font-size:26px!important; text-align:center; line-height:120%!important } h3 { font-size:20px!important; text-align:center; line-height:120%!important } h1 a { font-size:30px!important; text-align:center } h2 a { font-size:26px!important; text-align:center } h3 a { font-size:20px!important; text-align:center } .es-menu td a { font-size:14px!important } .es-header-body p, .es-header-body ul li, .es-header-body ol li, .es-header-body a { font-size:16px!important } .es-footer-body p, .es-footer-body ul li, .es-footer-body ol li, .es-footer-body a { font-size:14px!important } .es-infoblock p, .es-infoblock ul li, .es-infoblock ol li, .es-infoblock a { font-size:12px!important } *[class="gmail-fix"] { display:none!important } .es-m-txt-c, .es-m-txt-c h1, .es-m-txt-c h2, .es-m-txt-c h3 { text-align:center!important } .es-m-txt-r, .es-m-txt-r h1, .es-m-txt-r h2, .es-m-txt-r h3 { text-align:right!important } .es-m-txt-l, .es-m-txt-l h1, .es-m-txt-l h2, .es-m-txt-l h3 { text-align:left!important } .es-m-txt-r img, .es-m-txt-c img, .es-m-txt-l img { display:inline!important } .es-button-border { display:block!important } a.es-button { font-size:16px!important; display:block!important; border-left-width:0px!important; border-right-width:0px!important } .es-btn-fw { border-width:10px 0px!important; text-align:center!important } .es-adaptive table, .es-btn-fw, .es-btn-fw-brdr, .es-left, .es-right { width:100%!important } .es-content table, .es-header table, .es-footer table, .es-content, .es-footer, .es-header { width:100%!important; max-width:600px!important } .es-adapt-td { display:block!important; width:100%!important } .adapt-img { width:100%!important; height:auto!important } .es-m-p0 { padding:0px!important } .es-m-p0r { padding-right:0px!important } .es-m-p0l { padding-left:0px!important } .es-m-p0t { padding-top:0px!important } .es-m-p0b { padding-bottom:0!important } .es-m-p20b { padding-bottom:20px!important } .es-mobile-hidden, .es-hidden { display:none!important } .es-desk-hidden { display:table-row!important; width:auto!important; overflow:visible!important; float:none!important; max-height:inherit!important; line-height:inherit!important } .es-desk-menu-hidden { display:table-cell!important } table.es-table-not-adapt, .esd-block-html table { width:auto!important } table.es-social { display:inline-block!important } table.es-social td { display:inline-block!important } }
.rollover:hover .rollover-first {
	max-height:0px!important;
	display:none!important;
}
.rollover:hover .rollover-second {
	max-height:none!important;
	display:block!important;
}
#outlook a {
	padding:0;
}
.ExternalClass {
	width:100%;
}
.ExternalClass,
.ExternalClass p,
.ExternalClass span,
.ExternalClass font,
.ExternalClass td,
.ExternalClass div {
	line-height:100%;
}
.es-button {
	mso-style-priority:100!important;
	text-decoration:none!important;
}
a[x-apple-data-detectors] {
	color:inherit!important;
	text-decoration:none!important;
	font-size:inherit!important;
	font-family:inherit!important;
	font-weight:inherit!important;
	line-height:inherit!important;
}
.es-desk-hidden {
	display:none;
	float:left;
	overflow:hidden;
	width:0;
	max-height:0;
	line-height:0;
	mso-hide:all;
}
.es-button-border:hover {
	border-style:solid solid solid solid!important;
	background:#0ba4ca!important;
	border-color:#42d159 #42d159 #42d159 #42d159!important;
}
.es-button-border:hover a.es-button {
	background:#0ba4ca!important;
	border-color:#0ba4ca!important;
}
</style> 
 </head> 
 <body style="width:100%;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;padding:0;Margin:0;"> 
  <div class="es-wrapper-color" style="background-color:#F6F6F6;"> 
   <!--[if gte mso 9]>
			<v:background xmlns:v="urn:schemas-microsoft-com:vml" fill="t">
				<v:fill type="tile" color="#f6f6f6"></v:fill>
			</v:background>
		<![endif]--> 
   <table class="es-wrapper" width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;padding:0;Margin:0;width:100%;height:100%;background-repeat:repeat;background-position:center top;"> 
     <tr style="border-collapse:collapse;"> 
      <td class="st-br" valign="top" style="padding:0;Margin:0;"> 
       <table class="es-header" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;background-color:transparent;background-repeat:repeat;background-position:center top;"> 
         <tr style="border-collapse:collapse;"> 
          <td style="padding:0;Margin:0;background-image:url(https://eviuzb.stripocdn.email/content/guids/CABINET_d21e6d1c5a6807d34e1eb6c59a588198/images/20841560930387653.jpg);background-color:transparent;background-position:center bottom;background-repeat:no-repeat;" bgcolor="transparent" background="https://eviuzb.stripocdn.email/content/guids/CABINET_d21e6d1c5a6807d34e1eb6c59a588198/images/20841560930387653.jpg" align="center"> 
           <!--[if gte mso 9]><v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="mso-width-percent:1000;height:204px;"><v:fill type="tile" src="https://pics.esputnik.com/repository/home/17278/common/images/1546958148946.jpg" color="#343434" origin="0.5, 0" position="0.5,0" ></v:fill><v:textbox inset="0,0,0,0"><![endif]--> 
           <div> 
            <table class="es-header-body" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;" width="600" cellspacing="0" cellpadding="0" bgcolor="transparent" align="center"> 
              <tr style="border-collapse:collapse;"> 
               <td align="left" style="padding:0;Margin:0;padding-top:20px;padding-left:20px;padding-right:20px;"> 
                <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                  <tr style="border-collapse:collapse;"> 
                   <td width="560" valign="top" align="center" style="padding:0;Margin:0;"> 
                    <table width="100%" cellspacing="0" cellpadding="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                      <tr style="border-collapse:collapse;"> 
                       <td class="es-m-txt-c" align="center" style="padding:0;Margin:0;"><a target="_blank" href="https://fishy.ro" style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;font-size:14px;text-decoration:underline;color:#1376C8;"><img src="https://eviuzb.stripocdn.email/content/guids/CABINET_34320c0029e0d18b2498bf9cef84ff9e/images/57591580835285537.png" alt style="display:block;border:0;outline:none;text-decoration:none;-ms-interpolation-mode:bicubic;width:400px;height:51px;" height="51"></a></td> 
                      </tr> 
                      <tr style="border-collapse:collapse;"> 
                       <td height="65" align="center" style="padding:0;Margin:0;"></td> 
                      </tr> 
                    </table></td> 
                  </tr> 
                </table></td> 
              </tr> 
            </table> 
           </div> 
           <!--[if gte mso 9]></v:textbox></v:rect><![endif]--></td> 
         </tr> 
       </table> 
       <table class="es-content" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;"> 
         <tr style="border-collapse:collapse;"> 
          <td style="padding:0;Margin:0;background-color:transparent;" bgcolor="transparent" align="center"> 
           <table class="es-content-body" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;" width="600" cellspacing="0" cellpadding="0" bgcolor="transparent" align="center"> 
             <tr style="border-collapse:collapse;"> 
              <td align="left" style="Margin:0;padding-top:10px;padding-bottom:10px;padding-left:20px;padding-right:20px;"> 
               <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                 <tr style="border-collapse:collapse;"> 
                  <td width="560" valign="top" align="center" style="padding:0;Margin:0;"> 
                   <table width="100%" cellspacing="0" cellpadding="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                     <tr style="border-collapse:collapse;"> 
                      <td style="padding:0;Margin:0;"> 
                       <table class="es-menu" width="100%" cellspacing="0" cellpadding="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                         <tr class="links" style="border-collapse:collapse;"> 
                          <td style="Margin:0;padding-left:5px;padding-right:5px;padding-top:10px;padding-bottom:10px;border:0;" width="50%" valign="top" bgcolor="transparent" align="center"><a target="_blank" href="https://fishy.ro" style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;font-size:16px;text-decoration:none;display:block;color:#17C5F1;font-weight:bold;">Site</a></td> 
                          <td style="Margin:0;padding-left:5px;padding-right:5px;padding-top:10px;padding-bottom:10px;border:0;" width="50%" valign="top" bgcolor="transparent" align="center"><a target="_blank" href="https://discord.gg/xXnnjfk" style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;font-size:16px;text-decoration:none;display:block;color:#17C5F1;font-weight:bold;">Discord</a></td> 
                         </tr> 
                       </table></td> 
                     </tr> 
                   </table></td> 
                 </tr> 
               </table></td> 
             </tr> 
             <tr style="border-collapse:collapse;"> 
              <td style="Margin:0;padding-bottom:15px;padding-top:30px;padding-left:30px;padding-right:30px;border-radius:10px 10px 0px 0px;background-color:#FFFFFF;background-position:left bottom;" bgcolor="#ffffff" align="left"> 
               <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                 <tr style="border-collapse:collapse;"> 
                  <td width="540" valign="top" align="center" style="padding:0;Margin:0;"> 
                   <table style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-position:left bottom;" width="100%" cellspacing="0" cellpadding="0" role="presentation"> 
                     <tr style="border-collapse:collapse;"> 
                      <td align="center" style="padding:0;Margin:0;"><span style="font-size:32px;">Mulțumim că ai ales Fishy Hosting!</span><br></td> 
                     </tr> 
                     <tr style="border-collapse:collapse;"> 
                      <td align="center" style="padding:0;Margin:0;padding-top:20px;"><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;">Acest email a fost generat automat.<br></p></td> 
                     </tr> 
                   </table></td> 
                 </tr> 
               </table></td> 
             </tr> 
             <tr style="border-collapse:collapse;"> 
              <td style="Margin:0;padding-top:5px;padding-bottom:5px;padding-left:30px;padding-right:30px;border-radius:0px 0px 10px 10px;background-color:#FFFFFF;" align="left"> 
               <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                 <tr style="border-collapse:collapse;"> 
                  <td width="540" valign="top" align="center" style="padding:0;Margin:0;"> 
                   <table width="100%" cellspacing="0" cellpadding="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                     <tr style="border-collapse:collapse;"> 
                      <td align="left" style="padding:0;Margin:0;"> 
                       <div style="text-align:center;font-size:25px;"> 
                        <strong><span style="font-size:21px;">PhpMyAdmin:</span></strong> 
                       </div><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;">Înainte de a accesa phpmyadmin, va trebui să introduceți un user și o parolă, din motive de securitate:</p> 
                       <ul> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;"><strong>User:</strong> $apacheuser</li> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;"><strong>Parola:</strong> $apachepass</li> 
                       </ul><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;"><strong>User: </strong>root</p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;"><strong>Parola: </strong>$mysqlrootpass</p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;text-align:center;"><br></p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:21px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:32px;color:#131313;text-align:center;"><strong>Link logare</strong></p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;text-align:center;">https://$ip/$url</p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;text-align:center;"><br></p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:21px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:32px;color:#131313;text-align:center;"><strong>File Transfer Protocol (FTP)</strong><br></p> 
                       <div style="font-size:16px;text-align:center;">
                         Alegeți protocolul FTP, iar la Encryption alegeți „Require explicit FTP over TLS”. 
                        <br> 
                        <br> 
                       </div> 
                       <ul> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>Host: </strong>$ip</li> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>Port:</strong> 21</li> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>User: </strong>$sftpuser<br></li> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>Parola:</strong> $sftppass<br></li> 
                       </ul><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;text-align:left;"><br></p><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:21px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:32px;color:#131313;text-align:center;"><strong>Putty<br></strong></p> 
                       <ul> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>User: </strong>$sftpuser<br></li> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>Parola:</strong> $sftppass<br></li> 
                        <li style="-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;Margin-bottom:15px;color:#131313;text-align:left;"><strong>Port: </strong>$sshport</li> 
                       </ul><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;text-align:left;"><br></p></td> 
                     </tr> 
                   </table></td> 
                 </tr> 
               </table></td> 
             </tr> 
           </table></td> 
         </tr> 
       </table> 
       <table class="es-content" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;"> 
         <tr style="border-collapse:collapse;"> 
          <td align="center" style="padding:0;Margin:0;"> 
           <table class="es-content-body" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:transparent;" width="600" cellspacing="0" cellpadding="0" bgcolor="transparent" align="center"> 
             <tr style="border-collapse:collapse;"> 
              <td style="Margin:0;padding-top:5px;padding-bottom:5px;padding-left:30px;padding-right:30px;border-radius:0px 0px 10px 10px;background-position:left top;background-color:#FFFFFF;" align="left"> 
               <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                 <tr style="border-collapse:collapse;"> 
                  <td width="540" valign="top" align="center" style="padding:0;Margin:0;"> 
                   <table width="100%" cellspacing="0" cellpadding="0" role="presentation" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                     <tr style="border-collapse:collapse;"> 
                      <td align="center" style="padding:0;Margin:0;"> 
                       <div style="text-align:center;font-size:20px;"> 
                        <strong>Pentru instrucțiuni accesați:</strong> 
                       </div><p style="Margin:0;-webkit-text-size-adjust:none;-ms-text-size-adjust:none;mso-line-height-rule:exactly;font-size:16px;font-family:roboto, 'helvetica neue', helvetica, arial, sans-serif;line-height:24px;color:#131313;">https://wiki.fishy.ro<br></p></td> 
                     </tr> 
                   </table></td> 
                 </tr> 
               </table></td> 
             </tr> 
           </table></td> 
         </tr> 
       </table> 
       <table class="es-content" cellspacing="0" cellpadding="0" align="center" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;table-layout:fixed !important;width:100%;"> 
         <tr style="border-collapse:collapse;"> 
          <td style="padding:0;Margin:0;background-color:transparent;" bgcolor="transparent" align="center"> 
           <table class="es-content-body" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;background-color:#F7F7F7;" width="600" cellspacing="0" cellpadding="0" bgcolor="transparent" align="center"> 
             <tr style="border-collapse:collapse;"> 
              <td style="padding:0;Margin:0;border-radius:0px 0px 10px 10px;background-position:center bottom;background-color:#FFFFFF;" align="left"> 
               <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                 <tr style="border-collapse:collapse;"> 
                  <td width="600" valign="top" align="center" style="padding:0;Margin:0;"> 
                   <table width="100%" cellspacing="0" cellpadding="0" style="mso-table-lspace:0pt;mso-table-rspace:0pt;border-collapse:collapse;border-spacing:0px;"> 
                     <tr style="border-collapse:collapse;"> 
                      <td align="center" style="padding:0;Margin:0;display:none;"></td> 
                     </tr> 
                   </table></td> 
                 </tr> 
               </table></td> 
             </tr> 
           </table></td> 
         </tr> 
       </table></td> 
     </tr> 
   </table> 
  </div>  
 </body>
</html>
EOM

apt-get install mailutils -y

cat email.txt | mail --append="Content-type: text/html" -s "Fishy Hosting România - Detalii logare VPS" $2

cat email.txt | mail --append="Content-type: text/html" -s "Detalii logare VPS $ip" "support@fishy.ro"

elif [ -f "email.txt" ] >/dev/null 2>&1; then
echo "Email: Detaliile configurarii initiale au fost deja transmise."
else
echo "Email: Eroare trimitere detalii configurare initiala."
fi

rm email.txt

if [ ! -f /var/www/html/index.php ]; then
cd /var/www/html
rm index.html
cat >> index.php <<EOM
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Fishy Hosting</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

  <style>
  /*
 * Globals
 */

/* Links */
a,
a:focus,
a:hover {
  color: #fff;
}

/* Custom default button */
.btn-secondary,
.btn-secondary:hover,
.btn-secondary:focus {
  color: #333;
  text-shadow: none; /* Prevent inheritance from `body` */
  background-color: #fff;
  border: .05rem solid #fff;
}


/*
 * Base structure
 */

html,
body {
  height: 100%;
  background-color: #333;
}

body {
  display: -ms-flexbox;
  display: -webkit-box;
  display: flex;
  -ms-flex-pack: center;
  -webkit-box-pack: center;
  justify-content: center;
  color: #fff;
  text-shadow: 0 .05rem .1rem rgba(0, 0, 0, .5);
  box-shadow: inset 0 0 5rem rgba(0, 0, 0, .5);
}

.cover-container {
  max-width: 42em;
}


/*
 * Header
 */
.masthead {
  margin-bottom: 2rem;
}

.masthead-brand {
  margin-bottom: 0;
}

.nav-masthead .nav-link {
  padding: .25rem 0;
  font-weight: 700;
  color: rgba(255, 255, 255, .5);
  background-color: transparent;
  border-bottom: .25rem solid transparent;
}

.nav-masthead .nav-link:hover,
.nav-masthead .nav-link:focus {
  border-bottom-color: rgba(255, 255, 255, .25);
}

.nav-masthead .nav-link + .nav-link {
  margin-left: 1rem;
}

.nav-masthead .active {
  color: #fff;
  border-bottom-color: #fff;
}

@media (min-width: 48em) {
  .masthead-brand {
    float: left;
  }
  .nav-masthead {
    float: right;
  }
}


/*
 * Cover
 */
.cover {
  padding: 0 1.5rem;
}
.cover .btn-lg {
  padding: .75rem 1.25rem;
  font-weight: 700;
}


/*
 * Footer
 */
.mastfoot {
  color: rgba(255, 255, 255, .5);
}
  </style>
  </head>

<body class="text-center">

    <div class="cover-container d-flex h-100 p-3 mx-auto flex-column">
      <header class="masthead mb-auto">
        <div class="inner">
          <nav class="nav nav-masthead justify-content-center">
          </nav>
        </div>
      </header>

      <main role="main" class="inner cover">
        <h1 class="cover-heading">Bine ai venit</h1>
        <p class="lead">Din nefericire aceasta nu este pagina pe care o cauti.</p>
        <p class="lead">
        </p>
      </main>

      <footer class="mastfoot mt-auto">
        <div class="inner">
          <p>Gazduit de <a href="https://fishy.ro">Fishy Hosting</a>.</p>
        </div>
      </footer>
    </div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

</body>
</html>
EOM
elif [ -f /var/www/html/index.php ]; then
echo "Fisierul index.php a fost deja configurat."
else
echo "Eroare configurare index.php."
fi

cd
rm setup.sh
su $sftpuser
else
echo "Eroare configurare initala!!!"
fi