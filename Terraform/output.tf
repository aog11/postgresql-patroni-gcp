output "pgsql-vm1_name" {
    value = google_compute_instance.pgsql-vm[0].name
}

output "pgsql-vm1_ip_info" {
  value = "private: ${google_compute_instance.pgsql-vm[0].network_interface.0.network_ip}, public: ${google_compute_instance.pgsql-vm[0].network_interface.0.access_config.0.nat_ip}"
}

output "pgsql-vm2_name" {
    value = google_compute_instance.pgsql-vm[1].name
}

output "pgsql-vm2_ip_info" {
  value = "private: ${google_compute_instance.pgsql-vm[1].network_interface.0.network_ip}, public: ${google_compute_instance.pgsql-vm[1].network_interface.0.access_config.0.nat_ip}"
}

output "pgsql-vm3_name" {
    value = google_compute_instance.pgsql-vm[2].name
}

output "pgsql-vm3_ip_info" {
  value = "private: ${google_compute_instance.pgsql-vm[2].network_interface.0.network_ip}, public: ${google_compute_instance.pgsql-vm[2].network_interface.0.access_config.0.nat_ip}"
}

output "pgsql-vm_stby1_name" {
    value = google_compute_instance.pgsql-vm-stby[0].name
}

output "pgsql-vm_stby1_ip_info" {
  value = "private: ${google_compute_instance.pgsql-vm-stby[0].network_interface.0.network_ip}, public: ${google_compute_instance.pgsql-vm-stby[0].network_interface.0.access_config.0.nat_ip}"
}

output "pgsql-vm_stby2_name" {
    value = google_compute_instance.pgsql-vm-stby[1].name
}

output "pgsql-vm_stby2_ip_info" {
  value = "private: ${google_compute_instance.pgsql-vm-stby[1].network_interface.0.network_ip}, public: ${google_compute_instance.pgsql-vm-stby[1].network_interface.0.access_config.0.nat_ip}"
}

output "haproxy-vm_name" {
    value = google_compute_instance.haproxy-vm.name
}

output "haproxy-vm_ip_info" {
  value = "private: ${google_compute_instance.haproxy-vm.network_interface.0.network_ip}, public: ${google_compute_instance.haproxy-vm.network_interface.0.access_config.0.nat_ip}"
}
