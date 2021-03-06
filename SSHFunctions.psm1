#
# Export the module members - KUDOS to the chocolatey project for this efficent code
#


#get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -parent $MyInvocation.MyCommand.Definition)

#if ($global:winscpdllpath)
#{
#	#import winscp components
#	[Reflection.Assembly]::LoadFrom("$global:winscpdllpath")
#}
#else
#{
	#import winscp components
	[Reflection.Assembly]::LoadFrom("$mypath\winscp\WinSCPnet.dll")
#}

#find all the ps1 files in the subfolder functions
Resolve-Path $mypath\functions\*.ps1 | % { . $_.ProviderPath }

#export as module members the functions we specify
Export-ModuleMember -Function Connect-SshServer, disconnect-sshserver, download-sshfile, get-sshdirectorylist, upload-sshfile, test-sshfile, remove-sshfile, Connect-SSHServerFromIni, decrypt-winscppassword

#
# Define any alias and export them - Kieran Jacobsen
#

