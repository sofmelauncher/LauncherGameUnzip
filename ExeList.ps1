."./Log.ps1"

$basedir = (Convert-Path ../);

$date = (Get-Date -Format "yyyy-MM-dd")

#bin/ゲームの存在確認
$is_expanded = Test-Path "${basedir}\${GAME_DIR}"
Log "${basedir}\${GAME_DIR}の確認：${is_expanded}"

if ($is_expanded -eq 1) {
    Log "zipファイル探索ディレクトリ：${basedir}\Games"
    $exefiles = Get-ChildItem "${basedir}\Games" -Recurse | Where-Object { $_.Extension -eq ".exe" }
    
    foreach ($item in $exefiles) {
        TextLog "${item}"
    }
}
else {
    Log "データなし。"
}

