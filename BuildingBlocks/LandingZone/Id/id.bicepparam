using 'id.bicep'

// General settings
param location = 'westeurope' // Azure Region to deploy
param CustomerShort = 'htavr' 

// Network params
param vnetName = '${CustomerShort}-net-id'
param vnetRGName = '${CustomerShort}-net-id-rg'
param MainvNetName = '${CustomerShort}-net-main'
param MainvNetRGName = '${CustomerShort}-net-main-rg'
param MainvNetGWName = '${CustomerShort}-net-main-gw1'
param MainSubscriptionId = '23582489-fe22-40f9-9af0-56ca8ef37311'
param addressPrefix = ['10.2.0.0/16'] // must be a /16 prefix in an array.
