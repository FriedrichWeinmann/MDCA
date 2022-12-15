function Get-MdcaFile {
	<#
	.SYNOPSIS
		List or retrieve files.
	
	.DESCRIPTION
		List or retrieve files.
	
	.PARAMETER ID
		ID of the file to retrieve.
	
	.PARAMETER Skip
		Skip the first X results when listing files.
	
	.PARAMETER Limit
		Maximum number of files to retrieve.
	
	.PARAMETER Filter
		A custom filter as defined here: https://learn.microsoft.com/en-us/defender-cloud-apps/api-files#filters
		Example filter for public documents:
		@{
			fileType = @{ eq = 1 }
			sharing = @{ eq = 3 }
		}
	
	.EXAMPLE
		PS C:\> Get-MdcaFile

		List all files.

	.EXAMPLE
		PS C:\> Get-MdcaFile -ID 25e86014-b08d-4d42-a685-ca00a230c458

		Retrieve the specified file.
	#>
	[CmdletBinding(DefaultParameterSetName = 'default')]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = 'identity', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('_id')]
		[string[]]
		$ID,

		[Parameter(ParameterSetName = 'default')]
		[int]
		$Skip,

		[Parameter(ParameterSetName = 'default')]
		[int]
		$Limit,

		[hashtable]
		$Filter
	)

	begin {
		Assert-RestConnection -Service MDCA -Cmdlet $PSCmdlet
	}
	process {
		#region ID
		if ($ID) {
			foreach ($idString in $ID) {
				try { Invoke-RestRequest -Path "files/$idString" -ErrorAction Stop }
				catch { $PSCmdlet.WriteError($_) }
			}
			return
		}
		#endregion ID

		$body = @{ }
		$noPaging = $false
		if ($PSBoundParameters.ContainsKey("Skip")) { $body.skip = $Skip; $noPaging = $true }
		if ($PSBoundParameters.ContainsKey("Limit")) { $body.limit = $Limit; $noPaging = $true }
		if ($Filter) { $body.filters = $Filter }

		do {
			$result = Invoke-RestRequest -Path files -Body $body
			$body.skip = @($result.Data).Count + $body.skip
			$result.data
		}
		while ($result.hasNext -and -not $noPaging)
	}
}