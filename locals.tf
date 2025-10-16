locals {
  app_name       = var.app_name
  container_port = var.container_port
  tags           = merge(var.tags, { App = var.app_name })
}