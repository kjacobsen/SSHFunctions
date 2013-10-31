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
	[WinSCP.Protocol] $protocol = [WinSCP.Protocol]::Sftp,
	[string] $SshHostKeyFingerprint,
	[string] $SshPrivateKey,
	[string] $SshPrivateKeyPath,
	[switch] $IgnoreHostKey
)

#try to make a WinXCP session option object
#try {
	$sessionOptions = New-Object WinSCP.SessionOptions
#} catch {

#}

#Set the things WinSCP requires us to set
$sessionOptions.Protocol = $protocol
$sessionOptions.HostName = $hostname
$sessionOptions.UserName = $username

#lets start setting the optionals
$sessionOptions.Password = $password
#$sessionOptions.SshHostKeyFingerprint = $SshHostKeyFingerprint
$sessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $true

#$sessionOptions.PortNumber = $portnumer
#$sessionOptions.SshPrivateKey = $SshPrivateKey
#$sessionOptions.SshPrivateKeyPath = $SshPrivateKeyPath

#create a session
$session = New-Object WinSCP.Session

#attempt to connect
#try {
	$session.Open($sessionOptions)
#} catch {

#}

#return session

return $session
}
