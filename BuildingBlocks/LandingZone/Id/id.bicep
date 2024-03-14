
targetScope = 'subscription'
var DeploymentVersion = '1.0'
param DeploymentDate string = utcNow('yyyyMMdd')

param location string
param CustomerShort string

// networking
param vnetName string = '${CustomerShort}-net-id'
param vnetRGName string = '${CustomerShort}-net-id-rg'
param MainvNetName string = '${CustomerShort}-net-main'
param MainvNetRGName string = '${CustomerShort}-net-main-rg'
param MainSubscriptionId string = '23582489-fe22-40f9-9af0-56ca8ef37311'
param addressPrefix array = ['10.2.0.0/16']

var subnets = [
  {
    name: 'DomainServicesSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 12)
    networkSecurityGroupResourceId: DomainServicesSubnet_nsg.outputs.resourceId 
  }
  {
    name: 'AdminSubnet'
    addressPrefix: cidrSubnet(addressPrefix[0], 26, 18)
    networkSecurityGroupResourceId: AdminSubnet_nsg.outputs.resourceId
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

module VPNGWResourceExists 'br/public:avm/res/resources/deployment-script:0.1.3' = {
  name: 'VPNGWResourceExists'
  scope: vnetRG
  params: {
    name: 'VPNGWResourceExists'
    kind: 'AzurePowerShell'
    azPowerShellVersion: '11.3'
    managedIdentities: {
      userAssignedResourcesIds: ['/subscriptions/${MainSubscriptionId}/resourceGroups/htavr-ekcomgtresources-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/htavr-main-managed-identity']
    }
    arguments: MainvNetRGName
    scriptContent: '$DeploymentScriptOutputs = @{name = (Get-AzVirtualNetworkGateway -ResourcegroupName ${MainvNetRGName}).name}'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
    timeout: 'PT10M'
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
        useRemoteGateways: length(VPNGWResourceExists.outputs.outputs.name) > 0 ? true : false
      }
    ]
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
  }
  dependsOn: [
    DomainServicesSubnet_nsg
    AdminSubnet_nsg
    VPNGWResourceExists
  ]
}

module DomainServicesSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = {
  name: 'DomainServicesSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'DomainServicesSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
  }
}

module AdminSubnet_nsg 'br/public:avm/res/network/network-security-group:0.1.3' = {
  name: 'AdminSubnet-nsg'
  scope: vnetRG
  params: {
    name: 'AdminSubnet-nsg'
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
    }
  }
}

resource IdRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${CustomerShort}-id-rg'
  location: location
  tags: {
    DeploymentVersion: DeploymentVersion
    DeploymentDate: DeploymentDate
  }
}

module dcc1 'br/public:avm/res/compute/virtual-machine:0.2.2' = {
  name: '${CustomerShort}-id-dcc1'
  scope: IdRG
  params: {
    name: '${CustomerShort}-id-dcc1'
    adminUsername: '${CustomerShort}admin'
    adminPassword: '98*V>q0BrNKQ'
    managedIdentities: {
      systemAssigned: true
    }
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        nicSuffix: '-nic'
        deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: resourceId(subscription().subscriptionId, vnetRGName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, 'DomainServicesSubnet')
          }
        ]
        enableAcceleratedNetworking: false
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Detach' // Optional. Can be 'Delete' or 'Detach'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
      }
      tags: {
        DeploymentVersion: DeploymentVersion
        DeploymentDate: DeploymentDate
        kostenplaats: 'CloudDesktop'
      }
    }
    dataDisks: [
      {
        deleteOption: 'Detach'
        diskSizeGB: 8
        managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
        }
        tags: {
          DeploymentVersion: DeploymentVersion
          DeploymentDate: DeploymentDate
          kostenplaats: 'CloudDesktop'
        }
      }
    ]
    osType: 'Windows'
    vmSize: 'Standard_B2s'
    availabilityZone: 1
    encryptionAtHost: false
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
      kostenplaats: 'CloudDesktop'
    }
  }
  dependsOn: [vnet]
}

module dcc2 'br/public:avm/res/compute/virtual-machine:0.2.2' = {
  name: '${CustomerShort}-id-dcc2'
  scope: IdRG
  params: {
    name: '${CustomerShort}-id-dcc2'
    adminUsername: '${CustomerShort}admin'
    adminPassword: '98*V>q0BrNKQ'
    managedIdentities: {
      systemAssigned: true
    }
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        nicSuffix: '-nic'
        deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: resourceId(subscription().subscriptionId, vnetRGName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, 'DomainServicesSubnet')
          }
        ]
        enableAcceleratedNetworking: false
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Detach' // Optional. Can be 'Delete' or 'Detach'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
      }
      tags: {
        DeploymentVersion: DeploymentVersion
        DeploymentDate: DeploymentDate
        kostenplaats: 'CloudDesktop'
      }
    }
    dataDisks: [
      {
        deleteOption: 'Detach'
        diskSizeGB: 8
        managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
        }
        tags: {
          DeploymentVersion: DeploymentVersion
          DeploymentDate: DeploymentDate
          kostenplaats: 'CloudDesktop'
        }
      }
    ]
    osType: 'Windows'
    vmSize: 'Standard_B2s'
    availabilityZone: 2
    encryptionAtHost: false
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
      kostenplaats: 'CloudDesktop'
    }
  }
  dependsOn: [vnet]
}

module wac 'br/public:avm/res/compute/virtual-machine:0.2.2' = {
  name: '${CustomerShort}-id-wac1'
  scope: IdRG
  params: {
    name: '${CustomerShort}-id-wac1'
    adminUsername: '${CustomerShort}admin'
    adminPassword: '98*V>q0BrNKQ'
    managedIdentities: {
      systemAssigned: true
    }
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        nicSuffix: '-nic'
        deleteOption: 'Delete' // Optional. Can be 'Delete' or 'Detach'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: resourceId(subscription().subscriptionId, vnetRGName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, 'AdminSubnet')
          }
        ]
        enableAcceleratedNetworking: false
      }
    ]
    osDisk: {
      createOption: 'fromImage'
      deleteOption: 'Detach' // Optional. Can be 'Delete' or 'Detach'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
    }
    dataDisks: [
      {
          caching: 'ReadOnly'
          createOption: 'Empty'
          deleteOption: 'Detach' // Optional. Can be 'Delete' or 'Detach'
          diskSizeGB: '4'
          managedDisk: {
              storageAccountType: 'StandardSSD_LRS'
          }
          tags: {
            DeploymentVersion: DeploymentVersion
            DeploymentDate: DeploymentDate
            kostenplaats: 'CloudDesktop'
        }
      }
    ]
    }
    osType: 'Windows'
    vmSize: 'Standard_B2s'
    encryptionAtHost: false
    tags: {
      DeploymentVersion: DeploymentVersion
      DeploymentDate: DeploymentDate
      kostenplaats: 'CloudDesktop'
    }
  }
  dependsOn: [vnet]
}
