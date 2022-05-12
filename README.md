# Microsoft Defender for Cloud Apps

Welcome to the unofficial PowerShell module to interact with the API for Microsoft Defender for Cloud Apps (previously known as Microsoft Cloud App Security or MCAS).

## Installation

To install it and get ready to use the module, run this command on an internet facing computer:

```powershell
Install-Module MDCA -Scope CurrentUser
```

## Getting Started

To get ready to roll, you first need to prepare an App Registration in the Azure Portal and assign scopes as needed.
There is official documentation on how to do so:

+ [Application Context (aka: unattended)](https://docs.microsoft.com/en-us/defender-cloud-apps/api-authentication-application)
+ [User Context (interactive, MFA, ...)](https://docs.microsoft.com/en-us/defender-cloud-apps/api-authentication-user)

Once done, you can connect to the MCAS API thus:

```powershell
$clientID = '<insert app id>'
$tenantID = '<insert tenant ID>'
$tenantName = '<insert tenant name>'

# Logon as user
Connect-MdcaService -ClientID $clientID -TenantID $tenantID -TenantName $tenantName -DeviceCode

# Logon as application
Connect-MdcaService -ClientID $clientID -TenantID $tenantID -TenantName $tenantName -Certificate (Get-Item -Path "cert:\CurrentUser\My\<thumbprint>")
```

Once connected, the other commands of the module can be used to interact with the API.
For example:

```powershell
# List all subnets
Get-MdcaSubnet
```

> Note: Not all capabilities of the API have been mapped yet, more shall be added over time. If a specific API endpoint is missing that you want to use, file an issue and I'll try to prioritize those.

## Working with the API directly

Since not everything has been mapped so far, you may not want to wait for the commands to be created.
In the meantime, you can already use the connection and perform custom requests:

```powershell
# Retrieve all activities
Invoke-MdcaRequest -Path activities
```