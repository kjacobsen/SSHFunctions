function download-sshfile
{
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.INPUTS

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
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [String] $remotepath,
	[String] $Filename,
	[String] $Directory,
	[switch] $Clobber
)

begin
{

}

process
{
	#destination to download file to
	$Destination = ""
	
	<#
		This is a very complicated bit of code, but it handles all of the possibilities for the filename and directory parameters
		
		1) If both are specified -> join the two together
		2) If no filename or destination directory is specified -> the destination is the current directory (converted from .) joined with the "leaf" part of the url
		3) If no filename is specified, but a directory is -> the destination is the specified directory joined with the "leaf" part of the url
		4) If filename is specified but a directory is not -> The destination  is the current directory (converted from .) joined with the specified filename
	#>
	if (($Filename -ne "") -and ($Directory -ne "")) 
	{
		$Destination = Join-Path $Directory $Filename
	} 
 	elseif ((($Filename -eq $null) -or ($Filename -eq "")) -and (($Directory -eq $null) -or ($Directory -eq ""))) 
	{
		$Destination = Join-Path (Convert-Path ".") (Split-Path $remotepath -leaf)
	} 
	elseif ((($Filename -eq $null) -or ($Filename -eq "")) -and ($Directory -ne "")) 
	{
		$Destination = Join-Path $Directory (Split-Path $remotepath -leaf)
	} 
	elseif (($Filename -ne "") -and (($Directory -eq $null) -or ($Directory -eq ""))) 
	{
		$Destination = Join-Path (Convert-Path ".") $Filename
	}
		
	<#
		If the destination already exists and if clobber parameter is not specified then throw an error as we don't want to overwrite files, 
		else generate a warning and continue
	#>
	if (Test-Path $Destination) 
	{
		if ($Clobber) 
		{
			Write-Warning "Overwritting file"
		} 
		else 
		{
			throw "File already exists at destination: $destination, specify -Clobber to overwrite"
		}
	}

	Write-Verbose "Downloading $remotepath to $Destination"
	$transfers = $session.getfiles($remotepath, $Destination)
	
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
		Throw "Error occured during SSH Download - $($transfers.Failures)"
	} elseif ($transfers.transfers.count -eq 0) {
		Throw "No files downloaded using SSH"
	}
}

}
