
param location string = 'westeurope'
param CustomerShort string

// Network params
param vnetName string = '${CustomerShort}-net-main'
param vnetRGName string = '${CustomerShort}-net-main-rg'
param addressPrefix array = ['10.1.0.0/16']
param PrivateSubnet bool = true
param GatewaySubnet bool = false
param VPNPointToSiteSubnet bool = false
param AzureFireWallSubnet bool = false
param AzureBastionSubnet bool = false
param NetworkApplianceSubnet bool = false
param PerimeterSubnet bool = false
param ManagementSubnet bool = false
param AzureAppGwSubnet bool = false
param DesktopSubnet bool = false

// Optional NSG parameters
param NoPrivateSubnetNSG bool = false
param NoVPNPointToSiteSubnetNSG bool = false
param NoAzureBastionSubnetNSG bool = false
param NoNetworkApplianceSubnetNSG bool = false 
param NoPerimeterSubnetNSG bool = false
param NoManagementSubnetNSG bool = false
param NoAzureAppGwSubnetNSG bool = false
param NoDesktopSubnetNSG bool = false

var subnets = [
  {
    name: 'GatewaySubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 0)
    deploy: GatewaySubnet
  }
  {
    name: 'AzureFireWallSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 8)
    deploy: AzureFireWallSubnet
  }
  {
    name: 'VPNPointToSiteSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 2)
    networkSecurityGroupResourceId: (VPNPointToSiteSubnet && !NoVPNPointToSiteSubnetNSG) ? VPNPointToSiteSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: VPNPointToSiteSubnet
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 10)
    networkSecurityGroupResourceId: (AzureBastionSubnet && !NoAzureBastionSubnetNSG) ? AzureBastionSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: AzureBastionSubnet
  }
  {
    name: 'NetworkApplianceSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 14)
    networkSecurityGroupResourceId: (NetworkApplianceSubnet && !NoNetworkApplianceSubnetNSG) ? NetworkApplianceSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: NetworkApplianceSubnet
  }
  {
    name: 'PerimeterSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 6)
    networkSecurityGroupResourceId: (PerimeterSubnet && !NoPerimeterSubnetNSG) ? PerimeterSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: PerimeterSubnet
  }
  {
    name: 'ManagementSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 16)
    networkSecurityGroupResourceId: (ManagementSubnet && !NoManagementSubnetNSG) ? ManagementSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: ManagementSubnet
  }
  {
    name: 'AzureAppGwSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 1)
    networkSecurityGroupResourceId: (AzureAppGwSubnet && !NoAzureAppGwSubnetNSG) ? AzureAppGwSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: AzureAppGwSubnet
  }
  {
    name: 'PrivateSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 8)
    networkSecurityGroupResourceId: (PrivateSubnet && !NoPrivateSubnetNSG) ? PrivateSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: PrivateSubnet
  }
  {
    name: 'DesktopSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 1)
    networkSecurityGroupResourceId: (DesktopSubnet && !NoDesktopSubnetNSG) ? DesktopSubnet_nsg.outputs.resourceId : resourceId('${vnetRGName}', 'Microsoft.Network/networkSecurityGroups', 'NotDeployed')
    deploy: DesktopSubnet
  }
]

targetScope = 'subscription'

resource vnetRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: vnetRGName
  location: location
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'mainvnet'
  scope: vnetRG
  params: {
    name: vnetName
    addressPrefixes: addressPrefix
    subnets: filter(subnets, subnet => subnet.deploy == true)
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

module PrivateSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (PrivateSubnet && !NoPrivateSubnetNSG) {
  name: 'PrivateSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'PrivateSubnet-nsg'
  }
}

module VPNPointToSiteSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (VPNPointToSiteSubnet && !NoVPNPointToSiteSubnetNSG) {
  name: 'VPNPointToSiteSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'VPNPointToSiteSubnet-nsg'
  }
}

module AzureBastionSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (AzureBastionSubnet && !NoAzureBastionSubnetNSG) {
  name: 'AzureBastionSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AzureBastionSubnet-nsg'
  }
}

module NetworkApplianceSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (NetworkApplianceSubnet && !NoNetworkApplianceSubnetNSG) {
  name: 'NetworkApplianceSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'NetworkApplianceSubnet-nsg'
  }
}

module PerimeterSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (PerimeterSubnet && !NoPerimeterSubnetNSG) {  
  name: 'PerimeterSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'NetworkApplianceSubnet-nsg'
  }
}

module ManagementSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (ManagementSubnet && !NoManagementSubnetNSG) {
  name: 'ManagementSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'ManagementSubnet-nsg'
  }
}

module AzureAppGwSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (AzureAppGwSubnet && !NoAzureAppGwSubnetNSG) {
  name: 'AzureAppGwSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AzureAppGwSubnet-nsg'
  }
}

module DesktopSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DesktopSubnet && !NoDesktopSubnetNSG) {
  name: 'DesktopSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'DesktopSubnet-nsg'
  }
}
