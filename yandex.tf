terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "y0__xDC05fZAxjB3RMgwtvOgxY9Dr_2Y4TkKbzJCiARd5DhcmtjYQ"
  cloud_id  = "b1go3sc8hg6evcvb3ahj"
  folder_id = "b1g100kk55n7ma74fei1"
  zone      = "ru-central1-a"
}

# 1. Создаем сеть (чтобы серверу было где жить)
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

# 2. Создаем подсеть (subnet)
resource "yandex_vpc_subnet" "lab-subnet" {
  name           = "lab-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.lab-net.id
  v4_cidr_blocks = ["10.2.0.0/16"]
}

# 3. Создаем Сам Сервер
resource "yandex_compute_instance" "vm-yandex" {
  name = "ilia-yandex-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi" # Это Ubuntu 20.04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.lab-subnet.id
    nat       = true  # Дать серверу выход в интернет (белый IP)
  }

  metadata = {
    # Здесь мы хитрим: берем ваш публичный ключ прямо с сервера-агента
    ssh-keys = "ubuntu:${file("/home/ubuntu/ilia1.pem.pub")}"
  }
}

output "external_ip" {
  value = yandex_compute_instance.vm-yandex.network_interface.0.nat_ip_address
}
