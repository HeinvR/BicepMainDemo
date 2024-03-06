
targetScope = 'subscription'
var DeploymentVersion = '1.0'

param location string
param CustomerShort string

// networking
param vnetName string = '${CustomerShort}-net-id'
param vnetRGName string = '${CustomerShort}-net-id-rg'
param MainvNetName string = '${CustomerShort}-net-main'
param MainvNetRGName string = '${CustomerShort}-net-main-rg'
param MainSubscriptionId string = '23582489-fe22-40f9-9af0-56ca8ef37311'
param addressPrefix array = ['10.2.0.0/16']
param MainvNetGWName string = '${CustomerShort}-net-main-gw1'

var subnets = [
  {
    name: 'DomainServicesSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 12)
    networkSecurityGroupResourceId: DomainServicesSubnet_nsg.outputs.resourceId 
  }
  {
    name: 'AdminSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 18)
    networkSecurityGroupResourceId: AdminSubnet_nsg.outputs.resourceId
  }
]

resource vnetRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: vnetRGName
  location: location
  tags: {
    DeploymentVersion: DeploymentVersion
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'idvnet'
  scope: vnetRG
  params: {
    name: vnetName
    addressPrefixes: addressPrefix
    subnets: subnets
    peerings: [
      {
        remoteVirtualNetworkId: resourceId(MainSubscriptionId, MainvNetRGName, 'Microsoft.Network/virtualNetworks', '${MainvNetName}')
        remotePeeringEnabled: true
        remotePeeringAllowGatewayTransit: true
        useRemoteGateways: contains(resourceId(MainSubscriptionId, MainvNetRGName, 'Microsoft.Network/virtualNetworkGateways', '${MainvNetGWName}'), MainvNetGWName) ? true : false
      }
    ]
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
  dependsOn: [
    DomainServicesSubnet_nsg
    AdminSubnet_nsg
  ]
}

module DomainServicesSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = {
  name: 'DomainServicesSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'DomainServicesSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}

module AdminSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = {
  name: 'AdminSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AdminSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
    }
  }
}
