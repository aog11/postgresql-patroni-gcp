# PostgreSQL cluster with Patroni replication

The goal of this small project is to deploy and configure, with Terraform and Ansible, virtual machines in GCP that will be used to set up PostgreSQL replication with Patroni.

![image](https://user-images.githubusercontent.com/15926414/163117462-b4a45a51-c6da-451f-9d69-358c43b3a3e8.png)

## Extra
**04/04/2022** Deployed two additional PostgreSQL nodes to configure a standby cluster.

**08/04/2022** Configuration of Consul as DCS to save the status of the cluster.

## Credits
Special thanks to these two websites, which were used as guidance and reference for the setups contained in this exercise:

https://arctype.com/blog/postgres-patroni/

https://computingforgeeks.com/how-to-install-etcd-on-rhel-centos-rocky-almalinux/
