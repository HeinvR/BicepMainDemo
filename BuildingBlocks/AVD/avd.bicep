targetScope = 'subscription'
var DeploymentVersion = '1.0'
param DeploymentDate string = utcNow('yyyyMMdd')

param location string
param CustomerShort string

// networking
param vnetName string = '${CustomerShort}-net-avd'
param vnetRGName string = '${CustomerShort}-net-avd-rg'
param MainvNetName string = '${CustomerShort}-net-main'
param MainvNetRGName string = '${CustomerShort}-net-main-rg'
param MainSubscriptionId string = '23582489-fe22-40f9-9af0-56ca8ef37311'
param addressPrefix array = ['10.3.0.0/16']

// avd
param AvdRGName string = '${CustomerShort}-avd-rg'
param HostPoolsAndWorkspacesToDeploy array = [
  'clouddesktop'
  'acceptance'
  'test'
]

var subnets = [
  {
    name: 'DesktopSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 20, 1)
    networkSecurityGroupResourceId: DesktopSubnet_nsg.outputs.resourceId 
  }
]

resource vnetRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: vnetRGName
  location: location
  tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: vnetName
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
        useRemoteGateways: false
      }
    ]
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
  }
  dependsOn: [
    DesktopSubnet_nsg
  ]
}

module DesktopSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = {
  name: 'DesktopSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'DesktopSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
  }
}

resource AvdRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: AvdRGName
  location: location
  tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
}

resource AvdHostRGs 'Microsoft.Resources/resourceGroups@2022-09-01' = [for item in HostPoolsAndWorkspacesToDeploy: {
  name: '${CustomerShort}-avd-${item}-rg'
  location: location
  tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
}]

module hostpools'br/public:avm/res/desktop-virtualization/host-pool:0.1.2' = [for item in HostPoolsAndWorkspacesToDeploy: {
  name: '${CustomerShort}-avd-${item}-hp'
  scope: AvdRG
  params: {
    name: '${CustomerShort}-avd-${item}-hp'
    }
}]

module workspaces 'br/public:avm/res/desktop-virtualization/workspace:0.1.2' = [for item in HostPoolsAndWorkspacesToDeploy: {
  name: (item == 'clouddesktop') ? '${CustomerShort}-avd-workspace' : '${CustomerShort}-avd-workspace-${item}' 
  scope: AvdRG
  params: {
    name: item == 'clouddesktop' ? '${CustomerShort}-avd-workspace' : '${CustomerShort}-avd-workspace-${item}' 
    }
}]

resource AvdUpdRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${CustomerShort}-avdupd-rg'
  location: location
  tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
}

module AvdUpdSa 'br/public:avm/res/storage/storage-account:0.6.7' = {
  scope: AvdUpdRG
  name: '${CustomerShort}avdupd'
  params: {
    name: '${CustomerShort}avdupd'
    kind: 'FileStorage'
    skuName: 'Premium_LRS'
    fileServices: {
      shares: [for item in HostPoolsAndWorkspacesToDeploy: {
          enabledProtocols: 'SMB'
          name: item
          accessTier: 'Premium'
          shareQuota: 100
        }
      ]
      shareDeleteRetentionPolicy: {
        days: 14
        enabled: true
      }
    }  
  }
}

