#!/bin/sh

sh /opt/cassandra/bin/cassandra -f &

while ! grep -q "Created default superuser role 'cassandra" /opt/cassandra/logs/system.log
do
  sleep 120
done;
printf 'Create and populate the database.\n'
cqlsh -f $DEBEZIUM_HOME/inventory.cql
printf 'Database Execution finished\n'

while true;
do
  sleep 1
done;