terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project = var.project
  credentials = file(var.credentials_file)
  region = var.region
  zone = var.zone
}

#VPC configuration
resource "google_compute_network" "vnet-us-east1" {
  name = var.vpc_name
  auto_create_subnetworks = false
}

#Subnet for each set of machines
resource "google_compute_subnetwork" "subnet-etcd" {
  name = "subnet-etcd"
  ip_cidr_range = var.etcd_ip_range
  region = var.region
  network = google_compute_network.vnet-us-east1.id
}

resource "google_compute_subnetwork" "subnet-pgsql" {
  name = "subnet-pgsql"
  ip_cidr_range = var.pgsql_ip_range
  region = var.region
  network = google_compute_network.vnet-us-east1.id
}

resource "google_compute_subnetwork" "subnet-haproxy" {
  name = "subnet-haproxy"
  ip_cidr_range = var.haproxy_ip_range
  region = var.region
  network = google_compute_network.vnet-us-east1.id
}

#Firewall setup

#Private access between postgres nodes through ports 22, 5432, 8008
resource "google_compute_firewall" "pgsql_private_access" {
  name    = "fw-private-access-pgsql"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.pgsql_ip_range]
  target_tags = ["pgsql-nodes"]

  allow {
    protocol = "tcp"
    ports    = ["22", "5432", "8008"]
  }
}

#Private access from postgres nodes to etcd through ports 2379, 2380, 7001
resource "google_compute_firewall" "etcd_private_access" {
  name    = "fw-private-access-pgsql-to-etcd"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.pgsql_ip_range]
  target_tags = ["etcd-node"]

  allow {
    protocol = "tcp"
    ports    = ["2379", "2380", "7001"]
  }
}

#Private access from haproxy node to postgres nodes through ports 5432, 8008
resource "google_compute_firewall" "haproxy_private_access" {
  name    = "fw-private-access-haproxy-to-postgres"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.haproxy_ip_range]
  target_tags = ["pgsql-nodes"]

  allow {
    protocol = "tcp"
    ports    = ["5432","8008"]
  }
}

#Public access to the nodes through port 22
resource "google_compute_firewall" "public_access" {
  name    = "fw-public-access"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.user_public_ip]
  target_tags = ["etcd-node", "haproxy-node", "pgsql-nodes"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

#Public access to haproxy node through ports 31333, 31334
resource "google_compute_firewall" "haproxy_public_access" {
  name    = "fw-public-haproxy-access"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.user_public_ip]
  target_tags = ["haproxy-node"]

  allow {
    protocol = "tcp"
    ports    = ["31333", "31334"]
  }
}

#Disks to be used for postgres data directory
resource "google_compute_disk" "postgres-data-disk" {
  count = 2
  project = var.project
  name    = "postgres-data-disk-vm${count.index + 1}"
  type    = "pd-ssd"
  zone    = var.zone
  size    = 25
}

#PostgreSQL VMs creation, adding user's SSH keys for access
resource "google_compute_instance" "pgsql-vm" {
  count = 2
  name = "${var.pgsql_vm_name}${count.index + 1}"
  machine_type = "e2-standard-4"
  tags = ["pgsql-nodes"]
  network_interface {
    network = google_compute_network.vnet-us-east1.name
    subnetwork = google_compute_subnetwork.subnet-pgsql.name
    access_config {
    }
  }
  boot_disk {
    initialize_params {
      image = var.vm_image_name
    }
  }

  attached_disk {
    source = google_compute_disk.postgres-data-disk[count.index].self_link
    device_name = "postgres-data-disk0"
    mode = "READ_WRITE"
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }
}

#HAProxy VM creation, adding user's SSH keys for access
resource "google_compute_instance" "haproxy-vm" {
  name = "${var.haproxy_vm_name}"
  machine_type = "e2-standard-4"
  tags = ["haproxy-node"]
  network_interface {
    network = google_compute_network.vnet-us-east1.name
    subnetwork = google_compute_subnetwork.subnet-haproxy.name
    access_config {
    }
  }
  boot_disk {
    initialize_params {
      image = var.vm_image_name
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }
}

#etcd VM creation, adding user's SSH keys for access
resource "google_compute_instance" "etcd-vm" {
  name = "${var.etcd_vm_name}"
  machine_type = "e2-standard-4"
  tags = ["etcd-node"]
  network_interface {
    network = google_compute_network.vnet-us-east1.name
    subnetwork = google_compute_subnetwork.subnet-etcd.name
    access_config {
    }
  }
  boot_disk {
    initialize_params {
      image = var.vm_image_name
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }
}