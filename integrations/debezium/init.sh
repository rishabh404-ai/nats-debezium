#!/usr/bin/env sh
set -euo pipefail

# # Ensure all the services are up and running.
until nc -z nats 4222; do sleep 1; done
printf 'Success -> Step 1 : Nats Up & Running.\n'
until nc -z cassandra 9042; do sleep 1; done
printf 'Success -> Step 2 : Cassandra Up & Running.\n'
until nc -z debezium 8000; do sleep 1; done
printf 'Success -> Step 3 : Debezium Up & Running.\n'

# Allow Debezium to setup its connection to Cassandra.
sleep 5

until cqlsh -e "MyCluster" &> /dev/null; do
  echo "Waiting for Cassandra to start..."
  sleep 1
done

cqlsh -e "CREATE KEYSPACE commtel WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};"
cqlsh -e "USE codvo"
cqlsh -e "drop table if exists product"
cqlsh -e "CREATE TABLE commtel.product(id int PRIMARY KEY, product_name text, product_owner text, no_of_users int) WITH cdc=true"
cqlsh -e "ALTER TABLE product WITH cdc=true;"
cqlsh -e "INSERT INTO product (id, product_name, product_owner, no_of_users) values(123, 'commtel_product', 'commtel', 1245)"
cqlsh -e "insert into product (id, product_name, product_owner, no_of_users) values(0901, 'codvo_product', 'codvo', 1000)"
cqlsh -e "insert into product (id, product_name, product_owner, no_of_users) values(765, 'commtel_codvo_product', 'commtel_codvo', 2245)"
cqlsh -e "insert into product (id, product_name, product_owner, no_of_users) values(123, 'sample', 'sample', 10)"
printf 'Create and populate the cassandra.\n'