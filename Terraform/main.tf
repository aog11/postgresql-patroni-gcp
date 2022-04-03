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

resource "google_compute_subnetwork" "subnet-1" {
  name = var.vpc_subnet_name
  ip_cidr_range = var.vpc_ip_range
  region = var.region
  network = google_compute_network.vnet-us-east1.id
}

#Firewall setup

#Private access between nodes in through all the needed ports for the deployment (22, 5432, 2379, 2380, 8008, 31333, 31334)
resource "google_compute_firewall" "private_access" {
  name    = "fw-private-access"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.vpc_ip_range]

  allow {
    protocol = "tcp"
    ports    = ["22", "5432", "2379", "2380", "8008", "31333", "31334"]
  }
}

#Public access to the nodes through port 22
resource "google_compute_firewall" "public_access" {
  name    = "fw-public-access"
  network = google_compute_network.vnet-us-east1.name
  source_ranges = [var.user_public_ip]

  allow {
    protocol = "tcp"
    ports    = ["22"]
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
  network_interface {
    network = google_compute_network.vnet-us-east1.name
    subnetwork = google_compute_subnetwork.subnet-1.name
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

#Patroni VM creation, adding user's SSH keys for access
resource "google_compute_instance" "patroni-vm" {
  name = "${var.patroni_vm_name}"
  machine_type = "e2-standard-4"
  network_interface {
    network = google_compute_network.vnet-us-east1.name
    subnetwork = google_compute_subnetwork.subnet-1.name
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
  network_interface {
    network = google_compute_network.vnet-us-east1.name
    subnetwork = google_compute_subnetwork.subnet-1.name
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