terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
 
provider "yandex" {
  token     = "y0_AgAAAABwQra8AATuwQAAAADsX059ZcH7dtTDSuumYnxk-Nnzp-8Icdc"
  cloud_id  = "b1gol95gjnr240e8qb9m"
  folder_id = "b1g6c61dj5i3nebpjfg3"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "linux-vm1" {
  name        = "linux-vm1"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"
  resources {
    cores  = "2"
    memory = "2"
  }
  boot_disk {
    initialize_params {
      image_id = "fd87q4jvf0vdho41nnvr"
    }
  }
  network_interface {
    subnet_id = "e2lvck3cvbtm3cuba2vl"
  }
  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: admin\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOhTiBRVtJNFippucuSuIIoO2b8NgvTA+MVroTLy6ZQr2174SC6vFe9AuXQ2eLDspOQ5OoF5NJzFw4qq07DpbAlHpH6o71vfimRKBR8Wr9zcP5m4vlXXXgU/ATCZvEx/k3X4/S0aex8mAZh5LvCZGFPFfWacF9fKVsXt4NcqmYYIHldUZZaXM8RFAzl+1v2oRbhYSMKBSAsmU5OxM2SZzARShPqjsC/26e78O45cEAOZQ7zZAQtJHx5rgB45kpYKyrgKTttn3jAVQAqcbrQ0DTqLkxdjepRuwOxQHrKI1WWSfOlbaLpnym5plRq9aPnQSbn097N44ZIXktwZXSClv/ rsa-key-20230901"
  }
}

resource "yandex_compute_instance" "linux-vm2" {
  name        = "linux-vm2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"
  resources {
    cores  = "2"
    memory = "2"
  }
  boot_disk {
    initialize_params {
      image_id = "fd87q4jvf0vdho41nnvr"
    }
  }
  network_interface {
    subnet_id = "e2lvck3cvbtm3cuba2vl"
}
  
  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: admin\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCOhTiBRVtJNFippucuSuIIoO2b8NgvTA+MVroTLy6ZQr2174SC6vFe9AuXQ2eLDspOQ5OoF5NJzFw4qq07DpbAlHpH6o71vfimRKBR8Wr9zcP5m4vlXXXgU/ATCZvEx/k3X4/S0aex8mAZh5LvCZGFPFfWacF9fKVsXt4NcqmYYIHldUZZaXM8RFAzl+1v2oRbhYSMKBSAsmU5OxM2SZzARShPqjsC/26e78O45cEAOZQ7zZAQtJHx5rgB45kpYKyrgKTttn3jAVQAqcbrQ0DTqLkxdjepRuwOxQHrKI1WWSfOlbaLpnym5plRq9aPnQSbn097N44ZIXktwZXSClv/ rsa-key-20230901"
  }
}

#output "internal_ip_address_vm1" {
#  value = "data.yandex_compute_instance.linux-vm1.network_interface.0.ip_address"
#}

#output "internal_ip_address_vm2" {
#  value = "data.yandex_compute_instance.linux-vm2.network_interface.0.ip_address"
#}


resource "yandex_lb_target_group" "tgroup" {
  name      = "tgroup"
  target {
    subnet_id = "e2lvck3cvbtm3cuba2vl"
    address   = "${yandex_compute_instance.linux-vm1.network_interface.0.ip_address}"
  }
  target {
    subnet_id = "e2lvck3cvbtm3cuba2vl"
    address   = "${yandex_compute_instance.linux-vm2.network_interface.0.ip_address}"
  }
}