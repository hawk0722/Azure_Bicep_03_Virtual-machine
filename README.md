# Bicep Sample
## Azure Resource
This includes of the following resources:
- Resource groups
- Virtual Networks
- Virtual Machine
- Network security group
- Public IP Addresses
- Network Interface
- Managed Disks

## SystemConfiguration
![SystemConfiguration](/img/SystemConfiguration.svg)

## Network Infrastructure
![NetworkInfrastructure](/img/network.svg)

## Instructions
To get going with Bicep:
1. Start by [installing the tooling.](https://learn.microsoft.com/ja-jp/azure/azure-resource-manager/bicep/install)
2. Complete the [Bicep Learning Path.](https://learn.microsoft.com/ja-jp/training/paths/fundamentals-bicep/)
3. Update Parameters with your desired values.
4. Run the following command.

```cmd:Azure CLI
az login

az deployment sub create --template-file main.bicep --parameters adminUsername=<VM login account> --location <Your location>
```

## Notes
- The deployment was tested on windows.
