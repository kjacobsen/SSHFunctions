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
	$transfers = $session.Putfiles($LocalFile, $remotepath)
	
		
	foreach ($transfer in $transfers.transfers) {
		if ($transfer.error -eq $null) {
			$result = "Success"
		} else {
			$result = "Failure"
		}
		$fn = $transfer.filename
		$dn = $transfer.destination
		Write-Verbose "$fn -> $dn = $result"
	}
	
	Write-Verbose "tried to download a total of $($transfers.transfers.count) files"
	
	if ($transfers.failures.count -ne 0) {
		Throw "Error occured during SSH upload - $($transfers.Failures)"
	} elseif ($transfers.transfers.count -eq 0) {
		Throw "No files uploaded using SSH"
	}
}

}
