$ErrorActionPreferenceSilentlyContinue
$option = Read-Host "Turn usb Powermanagement for all usb devices on or off?"
 
switch ($option){
    {$_ -eq "on"} { Set-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI -Property @{Enable = $true} }
    {$_ -eq "off"} { Set-CimInstance -Query 'SELECT * FROM MSPower_DeviceEnable WHERE InstanceName LIKE "USB\\%"' -Namespace root/WMI -Property @{Enable = $false} }
    Default{$option = "Invalid Entry" }
}
#$result
Write-Host "Turning" $option "USB Powermanagement"