
targetScope = 'subscription'

param location string = 'westeurope'
param CustomerShort string

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
]
