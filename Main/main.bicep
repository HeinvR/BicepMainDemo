
targetScope = 'subscription'

param location string = 'westeurope'
param CustomerShort string = 'htavr'

// Subnets
param vnetName string = '${CustomerShort}-net-main'
param vnetRGName string = '${CustomerShort}-net-main-rg'
param addressPrefix array = ['10.1.0.0/16']
param DeployPrivateSubnet bool = true
param DeployGatewaySubnet bool = false
param DeployVPNPointToSiteSubnet bool = false
param DeployAzureFireWallSubnet bool = false
param DeployAzureBastionSubnet bool = false
param DeployNetworkApplianceSubnet bool = false
param DeployPerimeterSubnet bool = false
param DeployManagementSubnet bool = false
param DeployAzureAppGwSubnet bool = false
param DeployDesktopSubnet bool = false

// NSG
param DeployPrivateSubnetNSG bool = true
param DeployVPNPointToSiteSubnetNSG bool = true
param DeployAzureBastionSubnetNSG bool = true
param DeployNetworkApplianceSubnetNSG bool = true 
param DeployPerimeterSubnetNSG bool = true
param DeployManagementSubnetNSG bool = true
param DeployAzureAppGwSubnetNSG bool = true
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

var subnets = [
  {
    name: 'GatewaySubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 24, 0)
    deploy: DeployGatewaySubnet
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

module PrivateSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployPrivateSubnet && DeployPrivateSubnetNSG) {
  name: 'PrivateSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'PrivateSubnet-nsg'
  }
}

module VPNPointToSiteSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployVPNPointToSiteSubnet && DeployVPNPointToSiteSubnetNSG) {
  name: 'VPNPointToSiteSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'VPNPointToSiteSubnet-nsg'
  }
}

module AzureBastionSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployAzureBastionSubnet && DeployAzureBastionSubnetNSG) {
  name: 'AzureBastionSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AzureBastionSubnet-nsg'
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

module NetworkApplianceSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployNetworkApplianceSubnet && DeployNetworkApplianceSubnetNSG) {
  name: 'NetworkApplianceSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'NetworkApplianceSubnet-nsg'
  }
}

module PerimeterSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployPerimeterSubnet && DeployPerimeterSubnetNSG) {  
  name: 'PerimeterSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'NetworkApplianceSubnet-nsg'
  }
}

module ManagementSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployManagementSubnet && DeployManagementSubnetNSG) {
  name: 'ManagementSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'ManagementSubnet-nsg'
  }
}

module AzureAppGwSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployAzureAppGwSubnet && DeployAzureAppGwSubnetNSG) {
  name: 'AzureAppGwSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AzureAppGwSubnet-nsg'
  }
}

module DesktopSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = if (DeployDesktopSubnet && DeployDesktopSubnetNSG) {
  name: 'DesktopSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'DesktopSubnet-nsg'
  }
}
