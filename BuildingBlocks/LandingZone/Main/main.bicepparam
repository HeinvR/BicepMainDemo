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
param DeployVPNPointToSiteSubnet = false
param DeployAzureFireWallSubnet = false 
param DeployAzureBastionSubnet = false 
param DeployNetworkApplianceSubnet = false 
param DeployPerimeterSubnet = false
param DeployManagementSubnet = false
param DeployAzureAppGwSubnet = false
param DeployDesktopSubnet = false

// VPN gateway settings
param DeployGatewaySubnetAndVpnGw = false
param VPNGateWaySku = 'VpnGw1' // Only relevant when deploy parameter is set to true
param VPNGwActiveActiveMode = false // Only relevant when deploy parameter is set to true

/* By default an NSG will be deployed and associated with each subnet in a zero trust configuration. 
To overwrite this behaviour for a specific subnet and ignore NSG deployment / updates, adjust the parameter(s) below.
Usually not recommended.*/
param DeployPrivateSubnetNSG = false
param DeployVPNPointToSiteSubnetNSG = false
param DeployAzureBastionSubnetNSG = false
param DeployNetworkApplianceSubnetNSG = false 
param DeployPerimeterSubnetNSG = false
param DeployManagementSubnetNSG = false
param DeployAzureAppGwSubnetNSG = false
param DeployDesktopSubnetNSG = false

// Building block components to deploy
param DeployCustomerBackupVault = false
param DeployEkcoBackupVault = false

// MGTresources
param DeployEkcoMGTResources = false
