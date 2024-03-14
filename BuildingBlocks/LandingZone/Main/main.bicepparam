using 'main.bicep'

// General settings
param location = 'westeurope' // Azure Region to deploy
param CustomerShort = 'htavr'

// Network params, modify these settings based on the solution sold.
param DeployvNet = true
param vnetName = '${CustomerShort}-net-main'
param vnetRGName = '${CustomerShort}-net-main-rg'
param addressPrefix = ['10.1.0.0/16'] // must be a /16 prefix in an array.
param DeployPrivateSubnet = true
param DeployVPNPointToSiteSubnet = true
param DeployAzureFireWallSubnet = true 
param DeployAzureBastionSubnet = true 
param DeployNetworkApplianceSubnet = true 
param DeployPerimeterSubnet = true
param DeployManagementSubnet = true
param DeployAzureAppGwSubnet = true
param DeployDesktopSubnet = true

// VPN gateway settings
param DeployGatewaySubnetAndVpnGw = true
param VPNGateWaySku = 'VpnGw1' // Only relevant when deploy parameter is set to true
param VPNGwActiveActiveMode = false // Only relevant when deploy parameter is set to true

// Building block components to deploy
param DeployCustomerBackupVault = false
param DeployEkcoBackupVault = false

// MGTresources
param DeployEkcoMGTResources = true
