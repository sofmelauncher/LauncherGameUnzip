set LOG_FILE "Expandlog.log" -option constant
set GAME_DIR "file" -option constant

function Log($text, $Level) {
    $time = (Get-Date -Format 'yyyy/MM/dd-HH:mm:ss.fff')
    $Message = "INFO "
    switch ($Level) {
        2 {
            $Message = "ERROR"
        }
    }
    Write-Output "[${time}][${Message}] : ${text}";
}

function TextLog($text) {
    Write-Output "${text}";
}

$basedir = (Convert-Path ../);

$date = (Get-Date -Format "yyyy-MM-dd")
Start-Transcript -path "${basedir}\${date}-${LOG_FILE}" -append;


#bin/ゲームの存在確認
$is_expanded = Test-Path "${basedir}\${GAME_DIR}"
Log "${basedir}\${GAME_DIR}の確認：${is_expanded}"

if ($is_expanded -eq 1) {
    Log "解凍開始"
    Log "ランチャールートディレクトリ：${basedir}"
    $game_zip = $basedir + "\Games_zip";

    Log "ディレクトリ作成:${Game_zip}"
    $buff = New-Item $game_zip -ItemType Directory -Force;
    Log "ディレクトリ作成:${basedir}\Games"
    $buff = New-Item "${basedir}\Games" -ItemType Directory -Force;

    #ゲーム複製
    Get-ChildItem "${basedir}\${GAME_DIR}" | ForEach-Object -Process { Copy-Item -Force -Recurse $_.FullName "${basedir}\Games\" | Log "コピー:${_}から${basedir}\Games\" }

    Log "zipファイル探索ディレクトリ：${basedir}\Games"
    $zipfiles = Get-ChildItem "${basedir}\Games" -Recurse | Where-Object { $_.Extension -eq ".zip" }
    
    Log "Expand zip files..."
    foreach ($item in $zipfiles) {
        $destination = $item.FullName;
        $destination = $destination.Substring(0, $destination.Length - ($item.Extension).Length);
        $destinationParent = Split-Path $destination -Parent
        $buffer = New-Item -Path $destination -ItemType Directory -Force
        Log "解凍先： ${destination}"
        Log "解凍：${item}"
        Expand-Archive -Path $item.FullName -DestinationPath $destinationParent -Force
        Log "zipファイル移動：${item}"
        Move-Item $item.FullName $game_zip　-Force;
    }
    #元ゲームデータ削除
    #Remove-Item "${basedir}\bin\${GAME_DIR}\" -Recurse -Force

    TextLog "Zip List"
    foreach ($item in $zipfiles) {
        TextLog "${item}"
    }
}
else {
    Log "解凍データなし。"
}

Stop-Transcript