function Copy-RemoteFile {
    param (
        [string]$NetworkDrive,
        [string]$Username,
        [securestring]$Password,
        [string]$SourcePath,
        [string]$DestinationPath
    )

    # Find Available Drive D..Z in reverse order
    $drv = 90..69 | ForEach-Object{[char]$_}
    foreach ($drv in $drv) {

    if (Get-PSDrive $drv -ErrorAction SilentlyContinue) {
        Write-Host "The ${drv}: drive is already in use."
    } else {
        Write-Host "The ${drv}: drive is available."
        break
    }
    }
    $NetworkDrive = "${drv}:"

    # Map the network drive
    net use $NetworkDrive /user:$Username $Password

    # Change to the source directory
    Set-Location $SourcePath
    try {
        test-path $DestinationPath -ErrorAction Stop
    }
    catch {
        Write-Error "Destination path does not exist or is not accessible."
        return
    }
    # Copy the files to the destination
    copy-item $SourcePath -destination $DestinationPath -Recurse

    # Disconnect the network drive
    net use $NetworkDrive /delete
}
#net use <network drive> location /user:<username> <password>
#copy-item <file path> -destination #destination path -Recurse if full path
Copy-RemoteFile