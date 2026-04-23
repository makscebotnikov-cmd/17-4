# main.tf
# Задание 1: два remote-модуля для ВМ marketing и analytics

# === Сеть ===
#resource "yandex_vpc_network" "develop" {
#  name = "develop"
#}

#resource "yandex_vpc_subnet" "develop_a" {
#  name           = "develop-ru-central1-a"
#  zone           = var.default_zone
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = ["10.0.1.0/24"]
#}

# ### Task 2 ###
# === Сеть ===
module "vpc_dev" {
  source = "./vpc"
  
  env_name = "develop"
  zone     = var.default_zone
  cidr     = "10.0.1.0/24"
}

# === CLOUD-INIT ===
# Шаблон для marketing
data "template_file" "cloudinit_marketing" {
  template = file("${path.module}/cloud-init.yml.tpl")
  
  # Передаём переменные в шаблон
  vars = {
    ssh_public_key = var.ssh_public_key  # из variables.tf
    project_label  = "marketing"          # метка проекта
  }
}

# Шаблон для analytics
data "template_file" "cloudinit_analytics" {
  template = file("${path.module}/cloud-init.yml.tpl")
  
  # Передаём переменные в шаблон
  vars = {
    ssh_public_key = var.ssh_public_key
    project_label  = "analytics"
  }
}

# === remote-модуль для marketing-vm ===
module "marketing_vm" {
  # Remote-модуль из репозитория
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  
  # Параметры окружения
  env_name       = "develop"
  #network_id     = yandex_vpc_network.develop.id
  #subnet_zones   = [var.default_zone]
  #subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  
  # ### Task 2 ###
  network_id   = module.vpc_dev.network_id
  subnet_zones = [module.vpc_dev.subnet_zone]
  subnet_ids   = [module.vpc_dev.subnet_id]


  # Параметры ВМ
  instance_name  = "marketing-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  preemptible    = true
  
  # МЕТКИ: указываем принадлежность к проекту
  labels = { 
    owner   = var.owner_label
    project = "marketing"
  }

  # Передаём rendered cloud-init в метаданные
  metadata = {
    user-data          = data.template_file.cloudinit_marketing.rendered
    serial-port-enable = 1  # для отладки через консоль
  }
}

# === remote-модуль для analytics-vm ===
module "analytics_vm" {
  source = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  
  env_name       = "stage"
  #network_id     = yandex_vpc_network.develop.id
  #subnet_zones   = [var.default_zone]
  #subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  # ### Task 2 ###
  network_id   = module.vpc_dev.network_id
  subnet_zones = [module.vpc_dev.subnet_zone]
  subnet_ids   = [module.vpc_dev.subnet_id]

  instance_name  = "analytics-web"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  preemptible    = true
  
  # МЕТКИ: другой проект
  labels = { 
    owner   = var.owner_label
    project = "analytics"
  }

  metadata = {
    user-data          = data.template_file.cloudinit_analytics.rendered
    serial-port-enable = 1
  }
}v
