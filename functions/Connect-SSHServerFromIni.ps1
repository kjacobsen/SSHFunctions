function Connect-SSHServerFromIni
{
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.INPUTS
Nothing can be piped directly into this function

.EXAMPLE

.EXAMPLE

.OUTPUTS

.NOTES
NAME: 
AUTHOR: 
LASTEDIT: 
KEYWORDS:

.LINK

#>
[CMDLetBinding()]
param
(
	[Parameter(mandatory=$true)] [string] $SiteName,
	[string] $WinSCPIniPath
)
	$inifile = Get-IniContent $WinSCPIniPath
	
	$username = $inifile."Sessions\$SiteName".username
	$hostname = $inifile."Sessions\$SiteName".hostname
	
	Write-Verbose "$username@$hostname"
	
	if (($inifile."Sessions\$SiteName".Password -ne $null) -and ($inifile."Sessions\$SiteName".PublicKeyFile -ne $null))
	{
		$cryptpassword =$inifile."Sessions\$SiteName".Password
		Write-Verbose "Crypted password: $cryptpassword"
		$password = decrypt-winscppassword $cryptpassword $username $hostname
		Write-Verbose "Password: $password"
		$publickey = $inifile."Sessions\$SiteName".Replace("%5C", "\")
		Write-Verbose "Path to pubkey: $publickey"
		return Connect-SSHServer -hostname $hostname -username $username -password $password -SshPrivateKeyPath $publickey -IgnoreHostKey
	} 
	
	if (($inifile."Sessions\$SiteName".Password -ne $null) -and ($inifile."Sessions\$SiteName".PublicKeyFile -eq $null))
	{
		$cryptpassword =$inifile."Sessions\$SiteName".Password
		Write-Verbose "Crypted password: $cryptpassword"
		$password = decrypt-winscppassword $cryptpassword $username $hostname
		Write-Verbose "Password: $password"
		return Connect-SSHServer -hostname $hostname -username $username -password $password -IgnoreHostKey
	} 
	
	if (($inifile."Sessions\$SiteName".Password -eq $null) -and ($inifile."Sessions\$SiteName".PublicKeyFile -ne $null))
	{
		$publickey = $inifile."Sessions\$SiteName".Replace("%5C", "\")
		return Connect-SSHServer -hostname $hostname -username $username -SshPrivateKeyPath $publickey -IgnoreHostKey
	} 
}