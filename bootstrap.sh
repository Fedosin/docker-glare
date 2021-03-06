#!/bin/bash
set -x

export GLARE_CONFIG_FILE=/etc/glare/glare.conf
SQL_SCRIPT=${SQL_SCRIPT:-/root/glare.sql}

if env | grep -qi MYSQL_ROOT_PASSWORD && test -e $SQL_SCRIPT; then
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
    MYSQL_HOST=${MYSQL_HOST:-mysql}
    sed -i "s#^connection.*=.*#connection = mysql://glare:GLARE_DBPASS@${MYSQL_HOST}/glare#" $CONFIG_FILE
    mysql -uroot -p$MYSQL_ROOT_PASSWORD -h $MYSQL_HOST <$SQL_SCRIPT
fi

rm -f $SQL_SCRIPT

if [ -d  '/my_glare' ]
then
    # If custom volume with glare code is mounted, then use it as-is
    rm -rf /glare
    cp -r /my_glare /glare
    cd /glare
else
    # Pull latest changes
    cd /glare
    git pull
fi

pip install -e .

# Populate the Artifact service database
glare-db-manage --config-file /etc/glare/glare.conf upgrade

# Write openrc to disk
cat >/root/openrc <<EOF
export AUTH_TOKEN="admin:admin:admin"
export OS_GLARE_URL="http://${HOSTNAME}:9494"
EOF

# start glare service
/usr/local/bin/uwsgi --http 0.0.0.0:9494 --module glare.wsgi:application --workers 1 --logto /tmp/glare.log --logfile-chmod 644 -b 65535
