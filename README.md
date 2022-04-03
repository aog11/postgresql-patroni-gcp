# PostgreSQL cluster with Patroni replication

The goal of this small project is to deploy and configure, with Terraform and Ansible, virtual machines in GCP that will be used to set up PostgreSQL replication with Patroni.

## Environment
Taking as inspiration the guide found [here](https://arctype.com/blog/postgres-patroni/), we are going to deploy four virtual machines:

 - 2 postgres nodes
 - 1 etc node
 - 1 haproxy node

