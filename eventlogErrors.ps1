$days = Read-Host "How far back are we checking?" 
$StartTime = (Get-Date).AddDays(-$days)
$ErrorS = Get-WinEvent -FilterHashtable @{
	LogName='System'  
	Level=2
    StartTime=$StartTime
} | Select-Object TimeCreated, Id, ProviderName, Message
$ErrorA = Get-WinEvent -FilterHashtable @{
	LogName='Application'  
	Level=2
    StartTime=$StartTime
} | Select-Object TimeCreated, Id, ProviderName, Message
Write-Host "Errors"
$ErrorS+$ErrorA
#>"filepath tbd"