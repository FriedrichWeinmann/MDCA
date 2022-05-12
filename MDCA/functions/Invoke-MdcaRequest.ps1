function Invoke-MdcaRequest {
	<#
	.SYNOPSIS
		Execute a custom request against the MDCA API
	
	.DESCRIPTION
		Execute a custom request against the MDCA API
	
	.PARAMETER Path
		The relative path of the endpoint to query.
	
	.PARAMETER Body
		Any body content needed for the request.
	
	.PARAMETER Query
		Any query content to include in the request.
		In opposite to -Body this is attached to the request Url and usually used for filtering.
	
	.PARAMETER Method
		The Rest Method to use.
		Defaults to GET
	
	.PARAMETER Header
		The Rest Method to use.
		Defaults to GET
	
	.EXAMPLE
		PS C:\> Invoke-MdcaRequest -Path activities

		List all activities
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Path,

		[Hashtable]
		$Body = @{ },

		[Hashtable]
		$Query = @{ },

		[string]
		$Method = 'GET',

		[Hashtable]
		$Header = @{ }
	)
	
	process {
		$parameters = $PSBoundParameters | ConvertTo-PSFHashtable
		Invoke-RestRequest @parameters
	}
}