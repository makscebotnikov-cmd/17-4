# Публичные IP для подключения
output "marketing_vm_public_ip" {
  description = "Public IP of marketing VM"
  value       = module.marketing_vm.external_ip_address
}

output "analytics_vm_public_ip" {
  description = "Public IP of analytics VM"
  value       = module.analytics_vm.external_ip_address
}

# Метки для отчёта (требование задания)
output "marketing_vm_labels" {
  description = "Labels of marketing VM"
  value       = module.marketing_vm.labels
}

output "analytics_vm_labels" {
  description = "Labels of analytics VM"
  value       = module.analytics_vm.labels
}

# Превью cloud-init (опционально, для отладки)
output "marketing_cloud_init_preview" {
  description = "Preview of rendered cloud-init"
  value       = substr(data.template_file.cloudinit_marketing.rendered, 0, 200)
  sensitive   = true
}
