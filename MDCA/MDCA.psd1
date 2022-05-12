@{
	# Script module or binary module file associated with this manifest
	RootModule = 'MDCA.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.1'
	
	# ID used to uniquely identify this module
	GUID = '7b955241-e163-40f8-9d41-84433d2171a8'
	
	# Author of this module
	Author = 'Friedrich Weinmann'
	
	# Company or vendor of this module
	CompanyName = 'Microsoft'
	
	# Copyright statement for this module
	Copyright = 'Copyright (c) 2022 Friedrich Weinmann'
	
	# Description of the functionality provided by this module
	Description = 'Client for the Microsoft Defender for Cloud Apps API'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @(
		@{ ModuleName='PSFramework'; ModuleVersion='1.6.214' }
		@{ ModuleName='RestConnect'; ModuleVersion='1.0.9' }
	)
	
	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\MDCA.dll')
	
	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\MDCA.Types.ps1xml')
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @('xml\MDCA.Format.ps1xml')
	
	# Functions to export from this module
	FunctionsToExport = @(
		'Connect-MdcaService'
		'Get-MdcaSubnet'
		'Invoke-MdcaRequest'
		'New-MdcaSubnet'
		'Remove-MdcaSubnet'
		'Set-MdcaSubnet'
	)
	
	# Cmdlets to export from this module
	# CmdletsToExport = ''
	
	# Variables to export from this module
	# VariablesToExport = ''
	
	# Aliases to export from this module
	# AliasesToExport = ''
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('MCAS', 'Defender', 'App')
			
			# A URL to the license for this module.
			LicenseUri = 'https://github.com/FriedrichWeinmann/MDCA/blob/master/LICENSE'
			
			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/FriedrichWeinmann/MDCA'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			ReleaseNotes = 'https://github.com/FriedrichWeinmann/MDCA/blob/master/MDCA/changelog.md'
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}