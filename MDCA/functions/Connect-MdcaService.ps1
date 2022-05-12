function Connect-MdcaService {
	<#
	.SYNOPSIS
		Connect to the Microsoft Defender for Cloud Apps API
	
	.DESCRIPTION
		Connect to the Microsoft Defender for Cloud Apps API
	
	.PARAMETER ClientID
        ID of the registered/enterprise application used for authentication.

    .PARAMETER TenantID
        The ID of the tenant/directory to connect to.

	.PARAMETER TenantName
		The simple name of the tenant.
		Assuming the path to the MDCA portal is https://contoso.portal.cloudappsecurity.com/#/dashboard
		Then the TenantName would be "contoso"

    .PARAMETER Scopes
        Any scopes to include in the request.
        Only used for interactive/delegate workflows, ignored for Certificate based authentication or when using Client Secrets.

    .PARAMETER DeviceCode
        Use the Device Code delegate authentication flow.
        This will prompt the user to complete login via browser.

    .PARAMETER Certificate
        The Certificate object used to authenticate with.

        Part of the Application Certificate authentication workflow.

    .PARAMETER CertificateThumbprint
        Thumbprint of the certificate to authenticate with.
        The certificate must be stored either in the user or computer certificate store.

        Part of the Application Certificate authentication workflow.

    .PARAMETER CertificateName
        The name/subject of the certificate to authenticate with.
        The certificate must be stored either in the user or computer certificate store.
        The newest certificate with a private key will be chosen.

        Part of the Application Certificate authentication workflow.

    .PARAMETER CertificatePath
        Path to a PFX file containing the certificate to authenticate with.

        Part of the Application Certificate authentication workflow.

    .PARAMETER CertificatePassword
        Password to use to read a PFX certificate file.
        Only used together with -CertificatePath.

        Part of the Application Certificate authentication workflow.

    .PARAMETER ClientSecret
        The client secret configured in the registered/enterprise application.

        Part of the Client Secret Certificate authentication workflow.

    .PARAMETER Credential
        The credentials to use to authenticate as a user.

        Part of the Username and Password delegate authentication workflow.
        Note: This workflow only works with cloud-only accounts and requires scopes to be pre-approved.

	.PARAMETER Token
		A legacy token used to authorize API access.
		These tokens are deprecated and should be avoided, but not every migration can be accomplished instantaneously...
	
	.EXAMPLE
		PS C:\> Connect-MdcaService -ClientID $clientID -TenantID $tenantID -TenantName contoso -Certificate $cert

		Connect to the specified tenant using a certificate

	.EXAMPLE
		PS C:\> Connect-MdcaService -ClientID $clientID -TenantID $tenantID -TenantName contoso -DeviceCode

		Connect to the specified tenant using the DeviceCode flow
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = 'DeviceCode')]
		[Parameter(Mandatory = $true, ParameterSetName = 'AppCertificate')]
		[Parameter(Mandatory = $true, ParameterSetName = 'AppSecret')]
		[Parameter(Mandatory = $true, ParameterSetName = 'UsernamePassword')]
		[string]
		$ClientID,

		[Parameter(Mandatory = $true, ParameterSetName = 'DeviceCode')]
		[Parameter(Mandatory = $true, ParameterSetName = 'AppCertificate')]
		[Parameter(Mandatory = $true, ParameterSetName = 'AppSecret')]
		[Parameter(Mandatory = $true, ParameterSetName = 'UsernamePassword')]
		[string]
		$TenantID,

		[Parameter(Mandatory = $true)]
		[string]
		$TenantName,

		[string[]]
		$Scopes,

		[Parameter(ParameterSetName = 'DeviceCode')]
		[switch]
		$DeviceCode,

		[Parameter(ParameterSetName = 'AppCertificate')]
		[System.Security.Cryptography.X509Certificates.X509Certificate2]
		$Certificate,

		[Parameter(ParameterSetName = 'AppCertificate')]
		[string]
		$CertificateThumbprint,

		[Parameter(ParameterSetName = 'AppCertificate')]
		[string]
		$CertificateName,

		[Parameter(ParameterSetName = 'AppCertificate')]
		[string]
		$CertificatePath,

		[Parameter(ParameterSetName = 'AppCertificate')]
		[System.Security.SecureString]
		$CertificatePassword,

		[Parameter(Mandatory = $true, ParameterSetName = 'AppSecret')]
		[System.Security.SecureString]
		$ClientSecret,

		[Parameter(Mandatory = $true, ParameterSetName = 'UsernamePassword')]
		[PSCredential]
		$Credential,

		[Parameter(Mandatory = $true, ParameterSetName = 'LegacyToken')]
		[System.Security.SecureString]
		$Token
	)

	begin {
		$param = $PSBoundParameters | ConvertTo-PSFHashtable -ReferenceCommand Connect-RestService
		$param.Service = 'MDCA'
		$param.ServiceUrl = "https://$TenantName.portal.cloudappsecurity.com/api/v1"
		$param.Resource = '05a65629-4c1b-48c1-a78b-804c4abdd4af'
	}

	process {
		if ($Token) {
			Write-PSFMessage -Level Warning -String 'Connect-MdcaService.Deprecated' -Once TokenIsDeprecated
			$param = @{
				Service            = 'MDCA'
				ServiceUrl         = "https://$TenantName.portal.cloudappsecurity.com/api/v1"
				ValidAfter         = (Get-Date)
				ValidUntil         = (Get-Date).AddYears(500)
				Data               = @{ Token = $token }
				ExtraHeaderContent = @{ 'content-type' = 'application/json' }
				GetHeaderCode      = {
					param ($Data)
					
					$token = [PSCredential]::new("foo", $Data.Data.Token).GetNetworkCredential().Password
					@{ Authorization = "Token $token" }
				}
			}

			Set-RestConnection @param
			return
		}

		try { Connect-RestService @param -ErrorAction Stop }
		catch { $PSCmdlet.ThrowTerminatingError($_) }
		Set-RestConnection -Service MDCA -ExtraHeaderContent @{ 'content-type' = 'application/json' }
	}
}