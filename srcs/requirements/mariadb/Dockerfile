FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY my.cnf /etc/mysql/mariadb.conf.d/
COPY script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

VOLUME /var/lib/mysql
EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"]