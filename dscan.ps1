$ErrorActionPreferenceSilentlyContinue
Update-MpSignature -UpdateSource MicrosoftUpdateServer
Start-MpScan -ScanType QuickScan
$results = Get-MpThreatDetection
try{
    if ($results -eq ""){
    Write-Output "no results" | Out-File -FilePath .\results.txt -NoClobber
    }
    else{
    $results | Out-File -FilePath .\results.txt -NoClobber
    }
}
catch {
    Write-Host "Error has occured"
    Write-Host $_.ScriptStackTrace
}