Add-Type -TypeDefinition @"
	public enum SSH_ProxyType
	{
		None, 
		SOCKS4, 
		SOCKS5, 
		HTTP, 
		Telnet,
		Local
	}
"@

function connect-sshserver
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
	[Parameter(mandatory=$true)] [string] $hostname,
	[Parameter(mandatory=$true)] [string] $username,
	[string] $password,
	[int] $portnumer,
	[Winscp.Protocol] $protocol = [Winscp.Protocol]::SFTP,
	[string] $SshHostKeyFingerprint,
	[string] $SshPrivateKeyPath,
	[switch] $IgnoreHostKey = $false,
	[string] $ProxyHost,
	[int] $ProxyPort,
	[string] $ProxyUsername,
	[string] $ProxyPassword,
	[SSH_ProxyType] $ProxyType = [SSH_ProxyType]::None
)

#try to make a WinXCP session option object
try {
	$sessionOptions = New-Object WinSCP.SessionOptions
} catch {
	throw "Unable to create WinSCP.SessionOptions, confirm WinSCP DLL and executable are available"
}

#
#Set the things WinSCP requires us to set
#
$sessionOptions.HostName = $hostname
$sessionOptions.UserName = $username

#translate protocol type

$sessionOptions.Protocol = $protocol



#lets start setting the optionals
if (($password -eq $null) -and ($SshPrivateKeyPath -eq $null))
{
	throw "Now authentication specified"
}

if ($password)
{
	$sessionOptions.Password = $password
}

if ($SshHostKeyFingerprint)
{
	$sessionOptions.SshHostKeyFingerprint = $SshHostKeyFingerprint
}

if ($portnumber)
{
	$sessionOptions.PortNumber = $portnumer
}

if ($SshPrivateKeyPath)
{
	$sessionOptions.SshPrivateKeyPath = $SshPrivateKeyPath
}

$sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $IgnoreHostKey

if ($ProxyType -ne [SSH_ProxyType]::None)
{
	$sessionOptions.addrawsettings("ProxyHost", $ProxyHost)
	$sessionOptions.addrawsettings("ProxyMethod", $ProxyType.value__)
		
	if ($proxyPort)
	{
		$sessionOptions.addrawsettings("ProxyPort", $ProxyPort)
	}
	
	if ($proxyusername -and $ProxyPassword)
	{
		$sessionOptions.addrawsettings("ProxyUsername", $proxyusername)
		$sessionOptions.addrawsettings("ProxyPassword", $ProxyPassword)
	}
}

#create a session
$session = New-Object WinSCP.Session

#attempt to connect
try {
	$session.Open($sessionOptions)
} catch {
	Throw $_
}

return $session
}
