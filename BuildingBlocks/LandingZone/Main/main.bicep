
targetScope = 'subscription'

@description('Location to deploy. Within Ekco NL, "westeurope" is mostly used.')
param location string

@description('''The Customer ShortName. This name is used as a prefix for naming resources.
- Value must be between 3 and 6 characters in length and may contain letters only.
''')
@minLength(3)
@maxLength(6)
param CustomerShort string

@description('Specifies if the default vNet needs to be deployed.')
param DeployvNet bool = false

@description('Specifies if the default CustomerBackupVault needs to be deployed.')
param DeployCustomerBackupVault bool  = false

@description('Specifies if the default EkcoBackupVault needs to be deployed.')
param DeployEkcoBackupVault bool  = false

@description('''Specifies if Ekco management resources need to be deployed. This value typically is set to true if Ekco is managing the subscription. 
The following resources will be deployed:
- Managed Identity for automation purposes
- Log analytics workspace for logging purposes
- Azure Key Vault for storing secrets
- Azure storage account for temporary of cheap storage''')
param DeployEkcoMGTResources bool = true

// Network params
@description('The name of the vNet that will be deployed. The default value is *customershort*-net-main and can be overwritten using this parameter.')
param vnetName string = '${CustomerShort}-net-main'

@description('The name of the resourcegroup where the networking resources will be deployed in. The default value is *customershort*-net-main-rg and can be overwritten using this parameter.')
param vnetRGName string = '${CustomerShort}-net-main-rg'

@description('The AddressPrefix of the vNet. This prefix **must** be of type array and the first prefix **must** have a CIDR of /16. De default addressPrefix is [\'10.1.0.0/16\'] and can be overwritten using this parameter.')
param addressPrefix array = ['10.1.0.0/16']

@allowed(['ErGw1AZ', 'ErGw2AZ', 'ErGw3AZ', 'HighPerformance', 'Standard', 'UltraPerformance', 'VpnGw1', 'VpnGw1AZ'
  'VpnGw2', 'VpnGw2AZ', 'VpnGw3', 'VpnGw3AZ', 'VpnGw4', 'VpnGw4AZ', 'VpnGw5', 'VpnGw5AZ'
])
@description('Sku of the VPN Gateway')
param VPNGateWaySku string = 'VpnGw1'

@description('Specify whether the gateway needs to be deployed in Active-active mode. Active-active gateways have two Gateway IP configurations and two public IP addresses.')
param VPNGwActiveActiveMode bool = false

@description('''Specifies whether the 'PrivateSubnet' needs to be deployed. The default value for this parameter is 'true'. 
The following VM's typically will be deployed in this subnet.
- Customer and/or Ekco managed Application servers.
- Customer and/or Ekco managed SQL servers.
- Customer and/or Ekco managed Custom servers.
''')
param DeployPrivateSubnet bool = false

@description('''Specifies whether the 'GatewaySubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a Azure VPN Gateway resource.
The default value for this parameter is 'false'.''')
param DeployGatewaySubnetAndVpnGw bool = false

@description('''Specifies whether the 'VPNPointToSiteSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a point-to-site-vpn solution.
The default value for this parameter is 'false'.''')
param DeployVPNPointToSiteSubnet bool = false

@description('''Specifies whether the 'AzureFireWallSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy Azure Firewall.
The default value for this parameter is 'false'.''')
param DeployAzureFireWallSubnet bool = false

@description('''Specifies whether the 'AzureBastionSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy Azure Bastion.
The default value for this parameter is 'false'.''')
param DeployAzureBastionSubnet bool = false

@description('''Specifies whether the 'NetworkApplianceSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a NSv appliance. 
Be aware that no UDR's will be configured via this deployment. These need to be configured manually after deployment.
The default value for this parameter is 'false'.''')
param DeployNetworkApplianceSubnet bool = false

@description('''Specifies whether the 'PerimeterSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a perimeter subnet. 
This subnet can be used for a traditional DMZ setup.
The default value for this parameter is 'false'.''')
param DeployPerimeterSubnet bool = false

@description('''Specifies whether the 'ManagementSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a management subnet to host management VM's. 
The default value for this parameter is 'false'.''')
param DeployManagementSubnet bool = false

@description('''Specifies whether the 'AzureAppGwSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a Application Gateway resource. 
The default value for this parameter is 'false'.''')
param DeployAzureAppGwSubnet bool = false

@description('''Specifies whether the 'DesktopSubnet' needs to be deployed. 
This value needs to be set to 'true' when you want to host an AVD solution, which must be placed within close proximity to for example SQL or Application servers, with very low latency requiments. 
In most cases AVD deployments will be deployed in there own subscriptions via a dedicated deployment.
The default value for this parameter is 'false'.''')
param DeployDesktopSubnet bool = false

// NSG
@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployPrivateSubnetNSG bool = true

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployVPNPointToSiteSubnetNSG bool = true

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployAzureBastionSubnetNSG bool = true

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployNetworkApplianceSubnetNSG bool = true 

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployPerimeterSubnetNSG bool = true

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployManagementSubnetNSG bool = true

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployAzureAppGwSubnetNSG bool = true

@description('By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.')
param DeployDesktopSubnetNSG bool = true

// Subnets with or without NSG's
var DeployPrivateSubnetWithNSG = (DeployPrivateSubnet && DeployPrivateSubnetNSG)
var DeployVPNPointToSiteSubnetWithNSG = (DeployVPNPointToSiteSubnet && DeployVPNPointToSiteSubnetNSG)
var DeployAzureBastionSubnetWithNSG = (DeployAzureBastionSubnet && DeployAzureBastionSubnetNSG)
var DeployNetworkApplianceSubnetWithNSG = (DeployNetworkApplianceSubnet && DeployNetworkApplianceSubnetNSG)
var DeployPerimeterSubnetWithNSG = (DeployPerimeterSubnet && DeployPerimeterSubnetNSG)
var DeployManagementSubnetWithNSG = DeployManagementSubnet && DeployManagementSubnetNSG
var DeployAzureAppGwSubnetWithNSG = (DeployAzureAppGwSubnet && DeployAzureAppGwSubnetNSG)
var DeployDesktopSubnetWithNSG = (DeployDesktopSubnet && DeployDesktopSubnetNSG)

var DeploymentVersion = '1.0'

var subnets = [
  {
    name: 'GatewaySubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 0)
    deploy: DeployGatewaySubnetAndVpnGw
  }
  {
    name: 'AzureFireWallSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 8)
    deploy: DeployAzureFireWallSubnet
  }
  {
    name: 'VPNPointToSiteSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 2)
    networkSecurityGroupResourceId: (DeployVPNPointToSiteSubnet && DeployVPNPointToSiteSubnetNSG) ? VPNPointToSiteSubnet_nsg.outputs.resourceId : null
    deploy: DeployVPNPointToSiteSubnetWithNSG
  }
  {
    name: 'VPNPointToSiteSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 2)
    deploy: (DeployVPNPointToSiteSubnet && !DeployVPNPointToSiteSubnetWithNSG)
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 10)
    networkSecurityGroupResourceId: (DeployAzureBastionSubnet && DeployAzureBastionSubnetNSG) ? AzureBastionSubnet_nsg.outputs.resourceId : null
    deploy: DeployAzureBastionSubnetWithNSG
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 10)
    deploy: (DeployAzureBastionSubnet && !DeployAzureBastionSubnetWithNSG)
  }
  {
    name: 'NetworkApplianceSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 14)
    networkSecurityGroupResourceId: (DeployNetworkApplianceSubnet && DeployNetworkApplianceSubnetNSG) ? NetworkApplianceSubnet_nsg.outputs.resourceId : null
    deploy: DeployNetworkApplianceSubnetWithNSG
  }
  {
    name: 'NetworkApplianceSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 14)
    deploy: (DeployNetworkApplianceSubnet && !DeployNetworkApplianceSubnetWithNSG)
  }
  {
    name: 'PerimeterSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 6)
    networkSecurityGroupResourceId: (DeployPerimeterSubnet && DeployPerimeterSubnetNSG) ? PerimeterSubnet_nsg.outputs.resourceId : null
    deploy: DeployPerimeterSubnetWithNSG
  }
  {
    name: 'PerimeterSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 6)
    deploy: (DeployPerimeterSubnet && DeployPerimeterSubnetWithNSG)
  }
  {
    name: 'ManagementSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 16)
    networkSecurityGroupResourceId: (DeployManagementSubnet && DeployManagementSubnetNSG) ? ManagementSubnet_nsg.outputs.resourceId : null
    deploy: DeployManagementSubnetWithNSG
  }
  {
    name: 'ManagementSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 16)
    deploy: (DeployManagementSubnet && !DeployManagementSubnetWithNSG)
  }
  {
    name: 'AzureAppGwSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 1)
    networkSecurityGroupResourceId: (DeployAzureAppGwSubnet && DeployAzureAppGwSubnetNSG) ? AzureAppGwSubnet_nsg.outputs.resourceId : null
    deploy: DeployAzureAppGwSubnetWithNSG
  }
  {
    name: 'AzureAppGwSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 1)
    deploy: (DeployAzureAppGwSubnet && !DeployAzureAppGwSubnetWithNSG)
  }
  {
    name: 'PrivateSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 8)
    networkSecurityGroupResourceId: (DeployPrivateSubnet && DeployPrivateSubnetNSG) ? PrivateSubnet_nsg.outputs.resourceId : null
    deploy: DeployPrivateSubnetWithNSG
  }
  {
    name: 'PrivateSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 8)
    deploy: (DeployPrivateSubnet && !DeployPrivateSubnetWithNSG)
  }
  {
    name: 'DesktopSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 1)
    networkSecurityGroupResourceId: (DeployDesktopSubnet && DeployDesktopSubnetNSG) ? DesktopSubnet_nsg.outputs.resourceId : null
    deploy: DeployDesktopSubnetWithNSG
  }
  {
    name: 'DesktopSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 1)
    deploy: (DeployDesktopSubnet && !DeployDesktopSubnetWithNSG)
  }
]

resource vnetRG 'Microsoft.Resources/resourceGroups@2022-09-01' = if (DeployvNet) {
  name: vnetRGName
  location: location
  tags: {
    DeploymentVersion: DeploymentVersion
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.1' = if (DeployvNet) {
  name: 'mainvnet'
  scope: vnetRG
  params: {
    name: vnetName
    addressPrefixes: addressPrefix
    subnets: filter(subnets, subnet => subnet.deploy == true)
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
  dependsOn: [
    PrivateSubnet_nsg
    VPNPointToSiteSubnet_nsg
    AzureBastionSubnet_nsg
    NetworkApplianceSubnet_nsg
    PerimeterSubnet_nsg
    ManagementSubnet_nsg
    AzureAppGwSubnet_nsg 
    DesktopSubnet_nsg
  ]
}

module PrivateSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployPrivateSubnet && DeployPrivateSubnetNSG && DeployvNet) {
  name: 'PrivateSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'PrivateSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module VPNPointToSiteSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployVPNPointToSiteSubnet && DeployVPNPointToSiteSubnetNSG && DeployvNet) {
  name: 'VPNPointToSiteSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'VPNPointToSiteSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module AzureBastionSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployAzureBastionSubnet && DeployAzureBastionSubnetNSG && DeployvNet) {
  name: 'AzureBastionSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AzureBastionSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
    securityRules: [
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '5701'
            '8080'
          ]
          direction: 'Inbound'
          priority: 120
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 4095
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 4096
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSshRDPOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          direction: 'Outbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'AzureCloud'
          destinationPortRange: '443'
          direction: 'Outbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '5701'
            '8080'
          ]
          direction: 'Outbound'
          priority: 120
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowHttpOutbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: 'Internet'
          destinationPortRange: '80'
          direction: 'Outbound'
          priority: 130
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 140
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

module NetworkApplianceSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployNetworkApplianceSubnet && DeployNetworkApplianceSubnetNSG && DeployvNet) {
  name: 'NetworkApplianceSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'NetworkApplianceSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module PerimeterSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployPerimeterSubnet && DeployPerimeterSubnetNSG && DeployvNet) {  
  name: 'PerimeterSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'NetworkApplianceSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module ManagementSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployManagementSubnet && DeployManagementSubnetNSG && DeployvNet) {
  name: 'ManagementSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'ManagementSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module AzureAppGwSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployAzureAppGwSubnet && DeployAzureAppGwSubnetNSG && DeployvNet) {
  name: 'AzureAppGwSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AzureAppGwSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module DesktopSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployDesktopSubnet && DeployDesktopSubnetNSG && DeployvNet) {
  name: 'DesktopSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'DesktopSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module VPNGateway 'br/public:avm/res/network/virtual-network-gateway:0.1.1' = if (DeployGatewaySubnetAndVpnGw) {
  name: '${CustomerShort}-net-main-gw1'
  scope: vnetRG
  params: {
    gatewayType: 'Vpn'
    name: '${CustomerShort}-net-main-gw1'
    skuName: VPNGateWaySku
    vNetResourceId: vnet.outputs.resourceId
    activeActive: VPNGwActiveActiveMode
  }
}

resource EkcoMgtResourcesRG 'Microsoft.Resources/resourceGroups@2022-09-01' = if (DeployEkcoMGTResources){
  name: '${CustomerShort}-ekcomgtresources-rg'
  location: location
  tags: {
    DeploymentVersion: DeploymentVersion
  }
}

module ManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.1.3' = if (DeployEkcoMGTResources) {
  name: '${CustomerShort}-main-managed-identity'
  scope: EkcoMgtResourcesRG
  params: {
    name: '${CustomerShort}-main-managed-identity'
  }
}

module LogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.3.3' = if (DeployEkcoMGTResources) {
  name: '${CustomerShort}-main-log-analytics'
  scope: EkcoMgtResourcesRG
  params: {
    name: '${CustomerShort}-main-log-analytics'
  }
}

module KeyVault 'br/public:avm/res/key-vault/vault:0.3.5' = if (DeployEkcoMGTResources) {
  name: '${CustomerShort}-main-key-vault'
  scope: EkcoMgtResourcesRG
  params: {
    name: '${CustomerShort}-main-key-vault'
  }
}

module StorageAccount 'br/public:avm/res/storage/storage-account:0.6.6' = if (DeployEkcoMGTResources) {
  name: '${CustomerShort}-main-sa'
  scope: EkcoMgtResourcesRG
  params: {
    name: '${CustomerShort}mainsa${substring(subscription().subscriptionId, 0, 7)}'
  }
}
