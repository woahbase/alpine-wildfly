#!/bin/sh

cd ${WILDFLY_HOME} || exit 1;
chown -R ${PUID}:${PGID} /opt/jboss/;

PASSWORD="${PASSWORD:-insecurebydefault}";
s6-setuidgid ${PUID}:${PGID} ${WILDFLY_HOME}/bin/add-user.sh admin "${PASSWORD}" --silent

s6-setuidgid ${PUID}:${PGID} ${WILDFLY_HOME}/bin/standalone.sh  --server-config=${SERVERCONFIG} -b 0.0.0.0 -bmanagement 0.0.0.0

