."./Log.ps1"

Set-StrictMode -Off
Set-Variable PLAY_MOVIE_DIR "playMovie" -option constant
if ($GAME_DIR -ne $null) {
    Set-Variable GAME_DIR "file" -option constant
}
if ($LOG_FILE -ne $null) {
    Set-Variable LOG_FILE "Expandlog.log" -option constant
}

$basedir = (Convert-Path ../);
$date = (Get-Date -Format "yyyy-MM-dd")

function MovePlyaMovie {
    Start-Transcript -path "${basedir}\${date}-${LOG_FILE}" -append;

    #プレイ動画の移動
    Log "Move PlayMovie"
    Log "${basedir}\${GAME_DIR} -> ${basedir}\${PLAY_MOVIE_DIR}"
    $playMovieList = Get-ChildItem "${basedir}\${GAME_DIR}" -Recurse | Where-Object { $_.Directory.Name -eq "playmovie" }
    $movieDirList = Get-ChildItem "${basedir}\${GAME_DIR}" -Recurse | Where-Object { $_.Name -eq "playmovie" }

    TextLog "playMovie List"
    foreach ($item in $playMovieList) {
        TextLog "${item}"
    }

    if ($playMovieList.Length -ne 0) {
        Copy-StrictItemWithDirectoryStructure -inputPath $playMovieList -Destination "${basedir}\${PLAY_MOVIE_DIR}" -InputRoot "${basedir}\${GAME_DIR}"
    }

    foreach ($item in $movieDirList) {
        $t = $item.FullName
        Log "remove:${t}"
        #Remove-Item $item.FullName
    }
    Stop-Transcript  
}
  
