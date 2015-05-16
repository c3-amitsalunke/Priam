#!/bin/bash

# set up some variables
TOMCAT_HOME=/opt/tomcat
CASSANDRA_HOME=/usr/share/cassandra
# amazon uses different dir than ubuntu
CASSANDRA_CONF=/etc/cassandra/conf
CATALINA_CONF=/opt/tomcat/conf

### deploy priam
cp priam-web/build/libs/priam-web-2.0.12.war $TOMCAT_HOME/webapps/Priam.war
cp priam-cass-extensions/build/libs/priam-cass-extensions-2.0.12.jar $CASSANDRA_HOME/lib

### add to cassandra
sed -i '$aJAVA_AGENT="$JAVA_AGENT -javaagent:$CASSANDRA_HOME/lib/priam-cass-extensions-2.0.12.jar"' $CASSANDRA_HOME/cassandra.in.sh

# allow links in tomcat
sed -i 's/<Context>/<Context allowLinking="true">/' $CATALINA_CONF/context.xml

# add helper pages to webapp
cp priam.html $TOMCAT_HOME/webapps/ROOT/
cd $TOMCAT_HOME/webapps/ROOT/
ln -s $TOMCAT_HOME/logs/priam.log
ln -s $TOMCAT_HOME/logs/catalina.out
ln -s /var/log/cassandra/system.log
cd -
