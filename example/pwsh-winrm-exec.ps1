# 创建credential 对象
$username = 'jen';
$password = 'Nexus123!';
$secureString = ConvertTo-SecureString $password -AsPlaintext -Force;
$credential = New-Object System.Management.Automation.PSCredential $username, $secureString;

# 创建session, 结果中显示session id
New-PSSession -ComputerName 192.168.50.73 -Credential $credential

# 进入创建的session; session id
Enter-PSSession 1
