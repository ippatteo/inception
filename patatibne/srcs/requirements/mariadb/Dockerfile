FROM debian:oldstable

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*
#qui vanno i conf di maria db
COPY my.cnf /etc/mysql/mariadb.conf.d/  
COPY script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld
	#rende ex
	#crea cartella file temp
	#cambia gruppo e proprietario

VOLUME /var/lib/mysql
EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"]