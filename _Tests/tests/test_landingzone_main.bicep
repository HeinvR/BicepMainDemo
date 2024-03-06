targetScope = 'subscription'

module test_vnet_all_subnets_allnsgs '../../BuildingBlocks/LandingZone/Main/main.bicep' = {
  name: 'all_subnets_allnsgs'
  params: {
    CustomerShort: 'htavr'
    DeployPrivateSubnet: true 
    DeployGatewaySubnetAndVpnGw: true
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
