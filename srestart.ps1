$name = "Print Spooler"
$services = get-service $name
function Restart-ServiceByName {
        switch ($services.Status) {
            "Running" {
                Stop-Service $name -Force
                Start-Sleep -Seconds 5
                Start-Service $name
            }
            "StartPending" {
                Stop-Service $name -Force
                Start-Sleep -Seconds 5
                Start-Service $name
            }
            "Stopped" {
                Start-Service $name
                }
            "Paused" {
                Start-Service $name
            }
            "StopPending" {
                Start-Service $name
            }
            "ContinuePending" {
                Start-Service $name
            }
            "PausePending" {
                Start-Service $name 
            }
        }
    }
    try {
        Restart-ServiceByName
        Start-Sleep -Seconds 5
        if ($services.Status -ne "Running") {
            Restart-ServiceByName
        }
        else {
            Write-Host "Great Success"
        }
    }
    catch {
        Write-Host "Error has occured"
        Write-Host $_.ScriptStackTrace
    }