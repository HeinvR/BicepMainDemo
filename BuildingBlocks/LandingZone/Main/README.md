# Landing Zone - Main deployment

This template is used to deploy Azure Resources in the 'Main' customer subscription. This main subscription part of the Landing zone deployment and is the foundation on which all off the ekco services built upon.

The following components can be deployed by using this template. Modify input parameters to specify which resources will be deployed 
 - Azure Virtual Network resource, including subnets and NSG's. 
 - Log Analytics Workspace reource 
 - Two Recovery Services Vault (for customer and ekco services) 
 - A Managed Identity service principal for automation purposes 
 - An Azure Keyvault for storing secrets

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | Yes      | Location to deploy. Within Ekco NL, "westeurope" is mostly used.
CustomerShort  | Yes      | The Customer ShortName. This name is used as a prefix for naming resources. - Value must be between 3 and 6 characters in length and may contain letters only. 
vnetName       | No       | The name of the vNet that will be deployed. The default value is *customershort*-net-main and can be overwritten using this parameter.
vnetRGName     | No       | The name of the resourcegroup where the networking resources will be deployed in. The default value is *customershort*-net-main-rg and can be overwritten using this parameter.
addressPrefix  | No       | The AddressPrefix of the vNet. This prefix **must** be of type array and the first prefix **must** have a CIDR of /16. De default addressPrefix is ['10.1.0.0/16'] and can be overwritten using this parameter.
DeployPrivateSubnet | No       | Specifies whether the 'PrivateSubnet' needs to be deployed. The default value for this parameter is 'true'.  The following VM's typically will be deployed in this subnet. - Customer and/or Ekco managed Application servers. - Customer and/or Ekco managed SQL servers. - Customer and/or Ekco managed Custom servers. 
DeployGatewaySubnet | No       | Specifies whether the 'GatewaySubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a Azure VPN Gateway resource. The default value for this parameter is 'false'.
DeployVPNPointToSiteSubnet | No       | Specifies whether the 'VPNPointToSiteSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a point-to-site-vpn solution. The default value for this parameter is 'false'.
DeployAzureFireWallSubnet | No       | Specifies whether the 'AzureFireWallSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy Azure Firewall. The default value for this parameter is 'false'.
DeployAzureBastionSubnet | No       | Specifies whether the 'AzureBastionSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy Azure Bastion. The default value for this parameter is 'false'.
DeployNetworkApplianceSubnet | No       | Specifies whether the 'NetworkApplianceSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a NSv appliance.  Be aware that no UDR's will be configured via this deployment. These need to be configured manually after deployment. The default value for this parameter is 'false'.
DeployPerimeterSubnet | No       | Specifies whether the 'PerimeterSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a perimeter subnet.  This subnet can be used for a traditional DMZ setup. The default value for this parameter is 'false'.
DeployManagementSubnet | No       | Specifies whether the 'ManagementSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a management subnet to host management VM's.  The default value for this parameter is 'false'.
DeployAzureAppGwSubnet | No       | Specifies whether the 'AzureAppGwSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a Application Gateway resource.  The default value for this parameter is 'false'.
DeployDesktopSubnet | No       | Specifies whether the 'DesktopSubnet' needs to be deployed.  This value needs to be set to 'true' when you want to host an AVD solution, which must be placed within close proximity to for example SQL or Application servers, with very low latency requiments.  In most cases AVD deployments will be deployed in there own subscriptions via a dedicated deployment. The default value for this parameter is 'false'.
DeployPrivateSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployVPNPointToSiteSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployAzureBastionSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployNetworkApplianceSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployPerimeterSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployManagementSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployAzureAppGwSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.
DeployDesktopSubnetNSG | No       | By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Location to deploy. Within Ekco NL, "westeurope" is mostly used.

### CustomerShort

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The Customer ShortName. This name is used as a prefix for naming resources.
- Value must be between 3 and 6 characters in length and may contain letters only.


### vnetName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the vNet that will be deployed. The default value is *customershort*-net-main and can be overwritten using this parameter.

- Default value: `[format('{0}-net-main', parameters('CustomerShort'))]`

### vnetRGName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the resourcegroup where the networking resources will be deployed in. The default value is *customershort*-net-main-rg and can be overwritten using this parameter.

- Default value: `[format('{0}-net-main-rg', parameters('CustomerShort'))]`

### addressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The AddressPrefix of the vNet. This prefix **must** be of type array and the first prefix **must** have a CIDR of /16. De default addressPrefix is ['10.1.0.0/16'] and can be overwritten using this parameter.

- Default value: `10.1.0.0/16`

### DeployPrivateSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'PrivateSubnet' needs to be deployed. The default value for this parameter is 'true'. 
The following VM's typically will be deployed in this subnet.
- Customer and/or Ekco managed Application servers.
- Customer and/or Ekco managed SQL servers.
- Customer and/or Ekco managed Custom servers.


- Default value: `True`

### DeployGatewaySubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'GatewaySubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a Azure VPN Gateway resource.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployVPNPointToSiteSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'VPNPointToSiteSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a point-to-site-vpn solution.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployAzureFireWallSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'AzureFireWallSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy Azure Firewall.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployAzureBastionSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'AzureBastionSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy Azure Bastion.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployNetworkApplianceSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'NetworkApplianceSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a NSv appliance. 
Be aware that no UDR's will be configured via this deployment. These need to be configured manually after deployment.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployPerimeterSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'PerimeterSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a perimeter subnet. 
This subnet can be used for a traditional DMZ setup.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployManagementSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'ManagementSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a management subnet to host management VM's. 
The default value for this parameter is 'false'.

- Default value: `False`

### DeployAzureAppGwSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'AzureAppGwSubnet' needs to be deployed. This value needs to be set to 'true' when you want to deploy a Application Gateway resource. 
The default value for this parameter is 'false'.

- Default value: `False`

### DeployDesktopSubnet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies whether the 'DesktopSubnet' needs to be deployed. 
This value needs to be set to 'true' when you want to host an AVD solution, which must be placed within close proximity to for example SQL or Application servers, with very low latency requiments. 
In most cases AVD deployments will be deployed in there own subscriptions via a dedicated deployment.
The default value for this parameter is 'false'.

- Default value: `False`

### DeployPrivateSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployVPNPointToSiteSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployAzureBastionSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployNetworkApplianceSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployPerimeterSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployManagementSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployAzureAppGwSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

### DeployDesktopSubnetNSG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

By default every subnet will be deployed with an NSG. To overwrite this behaviour use this parameter.

- Default value: `True`

