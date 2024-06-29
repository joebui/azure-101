resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                            = "example-vmss"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  sku                             = "Standard_DS1_v2"
  instances                       = 1
  admin_username                  = "adminuser"
  admin_password                  = var.password
  disable_password_authentication = false
  health_probe_id                 = azurerm_lb_probe.example.id
  upgrade_mode                    = "Automatic"
  custom_data = base64encode(
    templatefile("${path.module}/scripts/custom_data.sh", {})
  )

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.one.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]
    }
  }
}
