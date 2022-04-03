# PostgreSQL cluster with Patroni replication

The goal of this small project is to deploy and configure, with Terraform and Ansible, virtual machines in GCP that will be used to set up PostgreSQL replication with Patroni.

## Environment
Taking as inspiration the guide found [here](https://arctype.com/blog/postgres-patroni/), we are going to deploy four virtual machines:

 - 2 postgres nodes with Patroni to handle replication and failover
 - 1 etc node
 - 1 haproxy node

## Result
The result of this deployment is roughly illustrated down below:

![image](https://user-images.githubusercontent.com/15926414/161445972-2a655689-c253-485c-b4eb-2d54af1f0f18.png)

1. Two PostgreSQL machines with Patroni installed to manage database initialization, replication and failover; these VMs are in their own subnet, with communication between them through ports 22, 5432 and 8008.
2. One etcd server that will server as the configuration storage for Patroni. This server resides in its own subnet, and is accessed by the database servers through ports 2379, 2380 and 7001.
3. One HAProxy server residing in a separte subnet, that queries the status of the database services, accessing the database subnet through ports 5432 and 8008.

For the purposes of this lab, two public access rules were configured:
1. Access to all the deployed machines through port 22 in order to run the setup.yml Ansible playbook.
2. Access to the HAProxy node through ports 31333 and 31334, to connect to the database and see the stats page.

## Credits
Special thanks to these two websites, which were used as guidance and reference for the setups contained in this exercise:

https://arctype.com/blog/postgres-patroni/

https://computingforgeeks.com/how-to-install-etcd-on-rhel-centos-rocky-almalinux/
