param VMNames array
param location string
param CustomerShort string

resource VMs 'Microsoft.Compute/virtualMachines@2023-03-01' existing = [for vm in VMNames: {
  name: '${vm}'
}]


resource windowsVMGuestConfigExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = [for i in range(0, length(VMNames)): {
  parent: VMs[i]
  name: '${CustomerShort}-AzurePolicyforWindows'
  location: location
  properties: {
    publisher: 'Microsoft.GuestConfiguration'
    type: 'ConfigurationforWindows'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {}
    protectedSettings: {}
  }
}]

resource symbolicname 'Microsoft.GuestConfiguration/guestConfigurationAssignments@2022-01-25' = [for i in range(0, length(VMNames)): {
  name: 'MyConfig1'
  location: location
  scope: VMs[i]
  properties: {
    guestConfiguration: {
      assignmentType: 'ApplyAndMonitor'
      contentHash: '60DA68D666886C90E9854CD59ABAF0FF6BAD9CAF9DE6639EDFF7E194032E1941'
      contentUri: 'https://github.com/HeinvR/TFAzureLab/raw/main/MyConfig1.zip'
      name: 'Generic'
      version: '1.1'
    }
  }
}]
