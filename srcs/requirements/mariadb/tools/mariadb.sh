#!/bin/sh

mysql_install_db

/etc/init.d/mysql start

#Check if the database exists

if [ -d "/var/lib/mysql/$DATABASE" ]
then 
	echo "Database already exists"
else

# Set root option so that connexion without root password is not possible

mysql_secure_installation << _EOF_

Y
42pass
42pass
Y
n
Y
Y
_EOF_

#Add a root user on 127.0.0.1 to allow remote connexion 
#Flush privileges allow to your sql tables to be updated automatically when you modify it
#mysql -uroot launch mysql command line client
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

#Create database and user in the database for wordpress

echo "CREATE DATABASE IF NOT EXISTS $DATABASE; GRANT ALL ON $DATABASE.* TO '$USER'@'%' IDENTIFIED BY '$PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root
fi

/etc/init.d/mysql stop

exec "$@"