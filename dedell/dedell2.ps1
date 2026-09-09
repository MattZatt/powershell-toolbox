<#EndGoal: 
    Remove all dell related software excluding dell watchdog timer
#>
$ErrorActionPreferenceSilentlyContinue
$hunted = "Dell"
$ignored = "Dell Watchdog Timer"
$Installed1 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$Installed2 += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$Installed3 += Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$Installed4 += Get-ItemProperty HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$program = @($Installed1;$Installed2;$Installed3;$Installed4)
$msiE = $program | Where-Object {$_.UninstallString -like 'MsiExec.exe' + '*'}
$NmsiE = $program | Where-Object {$_.UninstallString -notlike 'MsiExec.exe' + '*'}
function remdell {
    foreach($msiE in $msiE){
        $dmsiE = '"'+$msiE.PSChildName+'"'
        Start-Process MsiExec.exe -ArgumentList "/x $dmsiE /q /norestart" -Wait -NoNewWindow
    }
    foreach($NmsiE in $NmsiE){
        try {
            cmd /c $NmsiE.UninstallString += ' /quiet /norestart'
        }
        catch {
            $NmsiE.UninstallString += ' /S'   
        }
    }
    foreach($NmsiE in $NmsiE){
        try {
            cmd /c $NmsiE.QuietUninstallString
        }
        catch {
            Write-Host "Finalizing"
        }
    }
}
function cdell {
    try {
        if (Test-Path -Path $program) {
        remdell
        }
        else {
            Write-Host "No Dell software found"
        }
    }
    catch {
        Write-Host "No Dell software found"
    }
    Start-Sleep -Seconds 5
}
$query = Read-Host "Attempting to remove all dell software excluding dell watchdog timer, continue? (Y/N)"
switch ($query){
    {$_ -eq "Y"} { cdell }
    {$_ -eq "N"} { Write-Host "Exiting" }
    Default{$query = "Invalid Entry" }
}
$confirm = Read-Host "Complete sweep, Any remaining dell software will be removed, continue? (Y/N)"
switch ($confirm){
    {$_ -eq "Y"} { cdell }
    {$_ -eq "N"} { Write-Host "Exiting" }
    Default{$confirm = "Invalid Entry" }
}
Write-Host "Finializing, any remaining dell software will be removed on next reboot. If not please consider manual intervention"