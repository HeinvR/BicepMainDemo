param VMNames array
param location string
param CustomerShort string

resource VMs 'Microsoft.Compute/virtualMachines@2023-03-01' existing = [for vm in VMNames: {
  name: '${vm}'
}]

resource windowsVMGuestConfigExtension 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = [for i in range(0, length(VMNames)): {
  parent: VMs[i]
  name: 'AzurePolicyforWindows'
  location: location
  properties: {
    publisher: 'Microsoft.GuestConfiguration'
    type: 'ConfigurationforWindows'
    typeHandlerVersion: '1.29'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
    settings: {}
    protectedSettings: {}
  }
}]

resource GuestAssignment 'Microsoft.GuestConfiguration/guestConfigurationAssignments@2020-06-25' = [for i in range(0, length(VMNames)): {
  name: 'genericVM'
  location: location
  scope: VMs[i]
  properties: {
    guestConfiguration: {
      assignmentType: 'ApplyAndMonitor'
      contentHash: '76D0C44421BAC21D762EBDC835D903E69EA3963B00C3A075A0CF30087B44A6EB'
      contentUri: 'https://github.com/rednass47/testendpoint/raw/main/genericVM.zip'
      name: 'genericVM'
      version: '1.1'
    }
  }
}]
