using 'avd.bicep'

param location = 'westeurope'
param CustomerShort = 'htavr'

// Network params
param vnetName = '${CustomerShort}-net-avd'
param vnetRGName = '${CustomerShort}-net-avd-rg'
param MainvNetName = '${CustomerShort}-net-main'
param MainvNetRGName = '${CustomerShort}-net-main-rg'
param MainSubscriptionId = '23582489-fe22-40f9-9af0-56ca8ef37311'
param addressPrefix = ['10.3.0.0/16'] // must be a /16 prefix in an array.

// avd params
param AvdRGName = '${CustomerShort}-avd-rg'
param HostPoolsAndWorkspacesToDeploy = [
  'clouddesktop'
  'acceptance'
  'test'
]
