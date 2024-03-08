targetScope = 'subscription'

module test_vnet_all_subnets_allnsgs '../../BuildingBlocks/LandingZone/Main/main.bicep' = {
  name: 'allsubnetsallnsgs'
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
    DeployPrivateSubnetNSG: true
    DeployVPNPointToSiteSubnetNSG: true
    DeployAzureBastionSubnetNSG: true
    DeployNetworkApplianceSubnetNSG: true
    DeployPerimeterSubnetNSG: true
    DeployManagementSubnetNSG: true
    DeployAzureAppGwSubnetNSG: true
    DeployDesktopSubnetNSG: true
    location: 'global'
  }
}
