function remove-sshfile
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
	Write-Verbose "Removing $remotepath"
	$removals = $session.RemoveFiles($remotepath)
	
	
	foreach ($removal in $removals.removals) {
		if ($removal.error -eq $null) {
			$result = "Success"
		} else {
			$result = "Failure"
		}
		$fn = $removal.filename
		Write-Verbose "Deletion of $fn = $result"
	}
	
	Write-Verbose "tried to delete a total of $($removals.removals.count) files"
	
	if ($removals.failures.count -ne 0) {
		Throw "Error occured during deleting files - $($removals.Failures)"
	} elseif ($removals.removals.count -eq 0) {
		Throw "No files deleted using SSH"
	}
	
}

}
