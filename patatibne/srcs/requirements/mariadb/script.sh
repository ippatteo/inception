#!/bin/bash
set -eo pipefail #-e se fallisce stop, -o pip.. se una pipe fallisce

# Debug: mostra contenuto directory
echo "Controllo database esistente..."
ls -la /var/lib/mysql/

# Controllo se il database specifico esiste già "-d"
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Configurazione iniziale del database..."
    
    # Avvio temporaneo senza rete altrimenti sula porta root è vuo
    mysqld_safe --skip-networking --socket=/var/run/mysqld/mysqld.sock &
    MYSQL_PID=$! #memorizza il processo
    
    # Attesa con timeout
    for i in {30..0}; do
        if mysqladmin ping --socket=/var/run/mysqld/mysqld.sock; then
            break
        fi
        echo "Attesa avvio MariaDB ($i)..."
        sleep 1
    done
    
    # Configurazione iniziale
    mysql --socket=/var/run/mysqld/mysqld.sock <<-EOSQL
        SET @@SESSION.SQL_LOG_BIN=0;
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
#disatt. binary log
#crea data
#crea user
#da privilegi
#psw root
#garantisce funz.
    
    # Arresto pulito
    mysqladmin --socket=/var/run/mysqld/mysqld.sock -uroot shutdown
    wait $MYSQL_PID
fi

# Fix permessi
chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

# Avvio definitivo
echo "Avvio MariaDB..."
exec mysqld_safe --console --skip-networking=0
#sost processo
#controllore
#output in console
#toglie skip net