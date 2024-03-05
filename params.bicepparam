using 'main.bicep'

// General settings
param location = 'westeurope' // Azure Region to deploy
param CustomerShort = 'htavr' 

// Network params
param vnetName = '${CustomerShort}-net-main'
param vnetRGName = '${CustomerShort}-net-main-rg'
param addressPrefix = ['10.1.0.0/16'] // must be a /16 prefix in an array.
param PrivateSubnet = true // In most cases, customer managed VM's will be deployed here.
param GatewaySubnet = false // Required subnet when deploying a Virtual Network gateway.
param VPNPointToSiteSubnet = false // Subnet reserved for point to site (client VPN) connections.
param AzureFireWallSubnet = false // Subnet reserved for Azure firewall appliances.
param AzureBastionSubnet = false // Subnet reserved for Azure Bastion.
param NetworkApplianceSubnet = false // Subnet reserved for virtual network appliances.
param PerimeterSubnet = false // Subnet reserved for traditional DMZ setups.
param ManagementSubnet = false // Subnet reserved for management VM's.
param AzureAppGwSubnet = false // Subnet reserved for AzureAppGW's.
param DesktopSubnet = true // subnet reserverd for AVD solutions, when very low latency is required.

/* By default an NSG will be deployed and associated with each subnet in a zero trust configuration. 
To overwrite this behaviour for a specific subnet and ignore NSG deployment / updates, uncomment the parameter below.*/
// param NoPrivateSubnetNSG = true
// param NoVPNPointToSiteSubnetNSG = true
// param NoAzureBastionSubnetNSG = true
// param NoNetworkApplianceSubnetNSG = true 
// param NoPerimeterSubnetNSG = true
// param NoManagementSubnetNSG = true
// param NoAzureAppGwSubnetNSG = true
param NoDesktopSubnetNSG = true
