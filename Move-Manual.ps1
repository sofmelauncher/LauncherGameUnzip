."./Log.ps1"
."./Move-StrictItemWithDirectoryStructure.ps1"

Set-StrictMode -Off
Set-Variable MANUAL_DIR "manual" -option constant
if ($GAME_DIR -eq $null) {
}
Set-Variable GAME_DIR "file" -option constant
if ($LOG_FILE -eq $null) {
}
Set-Variable Ma_LOG_FILE "Expandlog.log" -option constant


function MoveManual {
    $basedir = (Convert-Path ../);
    $date = (Get-Date -Format "yyyy-MM-dd")
    Start-Transcript -path "${basedir}\${date}-${Ma_LOG_FILE}" -append;
    #プレイ動画の移動
    Log "Move Manual"
    Log "${basedir}\${GAME_DIR} -> ${basedir}\${MANUAL_DIR}"
    $ManualList = Get-ChildItem "${basedir}\${GAME_DIR}" -Recurse | Where-Object { $_.Directory.Name -eq "manual" }
    $ManualDirList = Get-ChildItem "${basedir}\${GAME_DIR}" -Recurse | Where-Object { $_.Name -eq "manual" }

    TextLog "Manual List"
    foreach ($item in $ManualList) {
        TextLog "${item}"
    }

    if ($ManualList.Length -ne 0) {
        Copy-StrictItemWithDirectoryStructure -inputPath $ManualList -Destination "${basedir}\${MANUAL_DIR}" -InputRoot "${basedir}\${GAME_DIR}"
    }

    foreach ($item in $ManualDirList) {
        $t = $item.FullName
        Log "remove:${t}"
        #Remove-Item $item.FullName
    }
    Stop-Transcript
}

MoveManual

