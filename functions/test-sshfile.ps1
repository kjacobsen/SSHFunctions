function test-sshfile
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
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [WinSCP.Session] $session,
	[Parameter(mandatory=$true)] [String] $remotepath
)

process {
	Write-Verbose "Testing if $remotepath exists"
	return $session.FileExists($remotepath)
}

}
