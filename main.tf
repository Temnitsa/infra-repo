terraform {
  required_version = ">= 0.14.0"
  required_providers {
    # Провайдер для OpenStack (был раньше)
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    # Провайдер для Yandex (добавляем сюда)
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

# Далее идет остальной код OpenStack (provider "openstack", resource...)
provider "openstack" {}
# Создаем сервер
resource "openstack_compute_instance_v2" "terraform_vm" {
  name            = "Ilia-Terraform-Server"  # Имя сервера
  image_name      = "ubuntu-20.04"           # Образ
  flavor_name     = "m1.small"               # Размер
  key_pair        = "ilia1"                  # Ваш ключ

  network {
    name = "sutdents-net"                    # Ваша сеть (с опечаткой)
  }
}

# Вывод IP адреса созданного сервера
output "server_ip" {
  value = openstack_compute_instance_v2.terraform_vm.access_ip_v4
}
