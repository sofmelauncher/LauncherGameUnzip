."./Log.ps1"

function MovePlyaMovie {
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
        Log "remove:${item}"
        Remove-Item $item.FullName
    }
}