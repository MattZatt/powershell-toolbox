<#EndGoal: 
    Remove all dell related software excluding dell watchdog timer
#>
$ErrorActionPreferenceSilentlyContinue
$hunted = "dell"
$ignored = "Dell Watchdog Timer"
$Installed1 = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$Installed2 += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$Installed3 += Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$Installed4 += Get-ItemProperty HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.PSObject.Properties.Value -like $hunted + '*' -notlike $ignored + '*'}
$program = @($Installed1;$Installed2;$Installed3;$Installed4)
$msiE = $program | Where-Object {$_.UninstallString -like 'MsiExec.exe' + '*'}
$NmsiE = $program | Where-Object {$_.UninstallString -notlike 'MsiExec.exe' + '*'}
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