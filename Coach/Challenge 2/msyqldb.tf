resource "azurerm_mysql_server" "mysql-server01" {
  name                              = "${var.mysqlserver}-${random_integer.random.result}"
  provider                          = azurerm.demo
  resource_group_name               = azurerm_resource_group.rg01.name
  location                          = azurerm_resource_group.rg01.location
  sku_name                          = var.mysql-sku-name
  version                           = var.mysql-version
  administrator_login               = var.mysql-admin-login
  administrator_login_password      = var.mysql-admin-password
  storage_mb                        = var.mysql-storage
  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true # issue with wordpress currently for ssl to be enforced code
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  threat_detection_policy {
    enabled              = true
    email_account_admins = true
    retention_days       = 7
  }

  tags = {
    env    = "demo"
    client = var.client
  }
}

resource "azurerm_mysql_database" "mysql-db01" {
  name                = "${var.mysqldb}-${random_integer.random.result}"
  provider            = azurerm.demo
  resource_group_name = azurerm_resource_group.rg01.name
  server_name         = azurerm_mysql_server.mysql-server01.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}


resource "azurerm_mysql_firewall_rule" "test" {
  name                = "mysql-rule"
  resource_group_name = azurerm_resource_group.rg01.name
  server_name         = azurerm_mysql_server.mysql-server01.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

