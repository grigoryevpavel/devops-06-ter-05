terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}
 

#создаем облачную сеть
resource "yandex_vpc_network" "network" {
  name = var.env_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "subnet" {
  for_each = { for s in var.subnets: index(var.subnets,s)=> s }
  name           = "${var.env_name}-${each.value.zone}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [each.value.cidr]
}
  

