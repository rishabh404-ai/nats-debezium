FROM cassandra:4.0

COPY startup-script.sh /startup-script.sh
COPY inventory.cql /inventory.cql

RUN chmod +x /startup-script.sh

USER cassandra

RUN chmod 777 /var/bin/cassandra

CMD /startup-script.sh