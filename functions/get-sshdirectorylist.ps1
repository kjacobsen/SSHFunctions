function get-sshdirectorylist
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

	Write-Verbose "Getting directory listing of $remotepath"
	return $session.ListDirectory($remotepath).files

}

