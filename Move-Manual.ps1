."./Log.ps1"

Set-Variable MANUAL_DIR "manual" -option constant
Set-Variable GAME_DIR "file" -option constant
Set-Variable LOG_FILE "Expandlog.log" -option constant

$basedir = (Convert-Path ../);
$date = (Get-Date -Format "yyyy-MM-dd")
Start-Transcript -path "${basedir}\${date}-${LOG_FILE}" -append;
function MoveManual {

    
    #プレイ動画の移動
    Log "Move Manual"
    Log "${basedir}\${GAME_DIR} -> ${basedir}\${MANUAL_DIR}"
    $ManualList = Get-ChildItem "${basedir}\${GAME_DIR}" -Recurse | Where-Object { $_.Directory.Name -eq "manual" }
    $ManualDirList = Get-ChildItem "${basedir}\${GAME_DIR}" -Recurse | Where-Object { $_.Name -eq "manual" }

    TextLog "playMovie List"
    foreach ($item in $ManualList) {
        TextLog "${item}"
    }

    if ($ManualList.Length -ne 0) {
        Copy-StrictItemWithDirectoryStructure -inputPath $ManualList -Destination "${basedir}\${MANUAL_DIR}" -InputRoot "${basedir}\${GAME_DIR}"
    }

    foreach ($item in $ManualDirList) {
        $t = $item.FullName
        Log "remove:${t}"
        Remove-Item $item.FullName
    }
}

Stop-Transcript