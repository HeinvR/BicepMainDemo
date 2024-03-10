using 'GuestConfiguration.bicep'

param CustomerShort = 'htavr'
param location = 'westeurope'
param VMNames = [
  '${CustomerShort}-id-dcc1'
  '${CustomerShort}-id-dcc2'
  '${CustomerShort}-id-wac1'
]
