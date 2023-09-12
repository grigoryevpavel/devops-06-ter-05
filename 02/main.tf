terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">=0.97.0"
    }
    template= {
      source = "hashicorp/template"
      version =">=2.2.0"
    }
  }
  backend "s3" {
    endpoint="storage.yandexcloud.net"
    bucket = "tfstate-developer"
    region = "ru-central1"
    key = "terraform.tfstate" 

    skip_region_validation = true
    skip_credentials_validation = true

    dynamodb_endpoint="https://docapi.serverless.yandexcloud.net/ru-central1/b1gp6i7k457jqkfdl7l9/etn4cr7cl6iqf8eib6nv" #точка подключения к ydb
    dynamodb_table = "tfstate-locks" #Таблица блокировок
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}



#создаем облачную сеть с подсетью

module "vpc_dev"{
  source="./modules/vpc_dev"
  zone=var.default_zone
  cidr_block=["10.0.1.0/24"]
  env_name  ="develop"
}

module "vpc_prod" {
  source       = "./modules/vpc_prod"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

# создаем ВМ
module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=95c286e"
  env_name        = "develop"
  network_id      = module.vpc_dev.vpc_network.id
  subnet_zones    = [var.default_zone]
  subnet_ids      = [ module.vpc_dev.vpc_subnet.id ]
  instance_name   = "web"
  instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered 
      serial-port-enable = 1
  }

}

#инициализация ВМ
data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")
 vars={
     public_key=var.public_key
 }
}

