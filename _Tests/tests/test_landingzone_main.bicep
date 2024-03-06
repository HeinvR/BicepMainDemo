targetScope = 'subscription'

module test_vnet_all_subnets_allnsgs '../../BuildingBlocks/LandingZone/Main/main.bicep' = {
  name: 'all_subnets_allnsgs'
  params: {
    CustomerShort: 'htavr'
    DeployPrivateSubnet: true 
    DeployGatewaySubnet: true
    DeployVPNPointToSiteSubnet: true
    DeployAzureFireWallSubnet: true 
    DeployAzureBastionSubnet: true 
    DeployNetworkApplianceSubnet: true
    DeployPerimeterSubnet: true
    DeployManagementSubnet: true
    DeployAzureAppGwSubnet: true
    DeployDesktopSubnet: true
    location: 'global'
  }
}

module test_vnet_all_subnets_nonsgs '../../BuildingBlocks/LandingZone/Main/main.bicep' = {
  name: 'all_subnets_nonsgs'
  params: {
    CustomerShort: 'htavr'
    DeployPrivateSubnet: true 
    DeployGatewaySubnet: true
    DeployVPNPointToSiteSubnet: true
    DeployAzureFireWallSubnet: true 
    DeployAzureBastionSubnet: true 
    DeployNetworkApplianceSubnet: true
    DeployPerimeterSubnet: true
    DeployManagementSubnet: true
    DeployAzureAppGwSubnet: true
    DeployDesktopSubnet: true
    DeployPrivateSubnetNSG: false
    DeployVPNPointToSiteSubnetNSG: false
    DeployAzureBastionSubnetNSG: false
    DeployNetworkApplianceSubnetNSG: false 
    DeployPerimeterSubnetNSG: false
    DeployManagementSubnetNSG: false
    DeployAzureAppGwSubnetNSG: false
    DeployDesktopSubnetNSG: false
    location: 'global'
  }
}
