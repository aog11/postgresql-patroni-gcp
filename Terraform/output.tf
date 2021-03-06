output "pgsql-vm_name" {
    value = google_compute_instance.pgsql-vm[*].name
}

output "pgsql-vm_ip_info" {
  value = [google_compute_instance.pgsql-vm[*].network_interface.0.network_ip, google_compute_instance.pgsql-vm[*].network_interface.0.access_config.0.nat_ip]
}

output "pgsql-vm_stby_name" {
    value = google_compute_instance.pgsql-vm-stby[*].name
}

output "pgsql-vm_stby_ip_info" {
  value = [google_compute_instance.pgsql-vm-stby[*].network_interface.0.network_ip, google_compute_instance.pgsql-vm-stby[*].network_interface.0.access_config.0.nat_ip]
}

output "haproxy-vm_name" {
    value = google_compute_instance.haproxy-vm.name
}

output "haproxy-vm_ip_info" {
  value = [google_compute_instance.haproxy-vm.network_interface.0.network_ip, google_compute_instance.haproxy-vm.network_interface.0.access_config.0.nat_ip]
}

output "etcd-vm_name" {
    value = google_compute_instance.etcd-vm.name
}

output "etcd-vm_ip_info" {
  value = [google_compute_instance.etcd-vm.network_interface.0.network_ip, google_compute_instance.etcd-vm.network_interface.0.access_config.0.nat_ip]
}
