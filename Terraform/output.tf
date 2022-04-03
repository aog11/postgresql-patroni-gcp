output "pgsql-vm_name" {
    value = google_compute_instance.pgsql-vm[*].name
}

output "pgsql-vm_ip_info" {
  value = [google_compute_instance.pgsql-vm[*].network_interface.0.network_ip, google_compute_instance.pgsql-vm[*].network_interface.0.access_config.0.nat_ip]
}

output "patroni-vm_name" {
    value = google_compute_instance.patroni-vm.name
}

output "patroni-vm_ip_info" {
  value = [google_compute_instance.patroni-vm.network_interface.0.network_ip, google_compute_instance.patroni-vm.network_interface.0.access_config.0.nat_ip]
}

output "etcd-vm_name" {
    value = google_compute_instance.etcd-vm.name
}

output "etcd-vm_ip_info" {
  value = [google_compute_instance.etcd-vm.network_interface.0.network_ip, google_compute_instance.etcd-vm.network_interface.0.access_config.0.nat_ip]
}
