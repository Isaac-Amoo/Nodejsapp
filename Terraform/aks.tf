 terraform {
  required_version = ">= 0.11" 
 backend "azurerm" {
  resource_group_name = "__terraformstoragerg__"
  storage_account_name = "__terraformstorageaccount__"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
	access_key  ="__storagekey__"
	}
	}
  provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "dev" {
  name     = "__TerraformRG__"
  location = "eastus"
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "__kubernetesCluster__"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}