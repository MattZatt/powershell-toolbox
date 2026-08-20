$s1 = get-service "wuauserv"
$s2 = get-service "cryptSvc"
$s3 = get-service "bits"
$s4 = get-service "msiserver"
function stop-services {
    Stop-Service $s1 -Force
    Stop-Service $s2 -Force
    Stop-Service $s3 -Force
    Stop-Service $s4 -Force
}
function start-services {
    Start-Service $s1
    Start-Service $s2
    Start-Service $s3
    Start-Service $s4
}
stop-services
Start-Sleep -Seconds 10
if ($s1.Status -eq "Stopped" -and $s2.Status -eq "Stopped" -and $s3.Status -eq "Stopped" -and $s4.Status -eq "Stopped") {
try {
    Rename-Item "C:\Windows\SoftwareDistribution" "C:\Windows\SoftwareDistribution.old" -Force
    Rename-Item "C:\Windows\System32\catroot2" "C:\Windows\System32\catroot2.old" -Force
    start-services
}
catch {
    Write-Host "Error has occured"
    Write-Host $_.ScriptStackTrace
}
}
else {
    Write-Host "Services are still running, please try again"
}