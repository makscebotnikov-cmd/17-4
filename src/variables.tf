# Task 1

variable "token" {
  description = "OAuth-токен для Яндекс.Облака"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID фолдера"
  type        = string
}

variable "default_zone" {
  description = "Зона по умолчанию"
  type        = string
  default     = "ru-central1-a"
}

variable "image_family" {
  description = "Image family for VM boot disk"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "ssh_public_key" {
  description = "Public SSH key for VM access"
  type        = string
  # default     = file("~/.ssh/id_ed25519.pub")
}

# Владелец для меток
variable "owner_label" {
  description = "Owner label for resources"
  type        = string
  default     = "mbrhard"
}
