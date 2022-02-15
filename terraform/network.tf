resource "azurerm_virtual_network" "network" {
    name = "ik-vnet"
    address_space = ["10.0.0.0/16"]
    location = "West US"
    resource_group_name = azurerm_resource_group.ik.name
}

resource "azurerm_public_ip" "web" {
    name = "web-public-ip"
    location = "West US"
    resource_group_name = azurerm_resource_group.ik.name
    allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "jenkins" {
    name = "jenkins-public-ip"
    location = "West US"
    resource_group_name = azurerm_resource_group.ik.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "security_group" {
    name = "ik-security-group"
    location = "West US"
    resource_group_name = azurerm_resource_group.ik.name
}

resource "azurerm_network_security_rule" "httpSecurity" {
  name                        = "http"
  priority                    = 340
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ik.name
  network_security_group_name = azurerm_network_security_group.security_group.name
}

resource "azurerm_network_security_rule" "httpsSecurity" {
  name                        = "https"
  priority                    = 320
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ik.name
  network_security_group_name = azurerm_network_security_group.security_group.name
}

resource "azurerm_network_security_rule" "sshSecurity" {
  name                        = "ssh"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ik.name
  network_security_group_name = azurerm_network_security_group.security_group.name
}

resource "azurerm_network_security_rule" "jenkinsSecurity" {
  name                        = "jenkins"
  priority                    = 360
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ik.name
  network_security_group_name = azurerm_network_security_group.security_group.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.ik.name
    virtual_network_name = azurerm_virtual_network.network.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create network interface
resource "azurerm_network_interface" "web" {
    name                      = "ik-web"
    location                  = "West US"
    resource_group_name       = azurerm_resource_group.ik.name

    ip_configuration {
        name                          = "web-configuration"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.web.id
    }
}

# Create network interface
resource "azurerm_network_interface" "jenkins" {
    name                      = "ik-jenkins"
    location                  = "West US"
    resource_group_name       = azurerm_resource_group.ik.name

    ip_configuration {
        name                          = "jenkins-configuration"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.jenkins.id
    }
}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "web" {
    network_interface_id      = azurerm_network_interface.web.id
    network_security_group_id = azurerm_network_security_group.security_group.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "jenkins" {
    network_interface_id      = azurerm_network_interface.jenkins.id
    network_security_group_id = azurerm_network_security_group.security_group.id
}
