function upload-sshfile
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
	[Parameter(mandatory=$true)] [WinSCP.Session] $session,
	[Parameter(mandatory=$true)] [String] $remotepath,
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [String] $LocalFile
)

Process
{
	#test that the file we are trying to send exists, else throw error.
	if (! (Test-Path $LocalFile)) 
	{
		Throw "Could not find local file $localfile"
	}

	Write-Verbose "uploading $LocalFile to $remotepath"
	$session.Putfiles($LocalFile, $remotepath).check()
}

}