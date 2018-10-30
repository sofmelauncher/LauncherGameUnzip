set LOG_FILE "Expandlog.log" -option constant
set GAME_DIR "file" -option constant

function Log($text, $Level){
    $time = (Get-Date -Format 'yyyy/MM/dd-HH:mm:ss.fff')
    $Message = "INFO "
    switch ($Level) {
        2 {
            $Message = "ERROR"
        }
    }
    Write-Output "[${time}][${Message}] : ${text}";
}

function NoTimeLog($text){
    Write-Output "${text}";
}

$date = (Get-Date -Format "yyyy-MM-dd")
Start-Transcript -path "${date}-${LOG_FILE}" -append;

$basedir = (Convert-Path ../);

#bin/ゲームの存在確認
$is_expanded = Test-Path "${basedir}\bin\${GAME_DIR}"
Log "${basedir}\bin\${GAME_DIR}の確認：${is_expanded}"

if($is_expanded -eq 1){
    Log "解凍開始"
    Log "ランチャールートディレクトリ：${basedir}"
    $game_zip = $basedir + "\gomi_zip";

    Log "ディレクトリ作成:${game_zip}"
    $buff = New-Item $game_zip -ItemType Directory -Force;
    Log "ディレクトリ作成:${basedir}\game"
    $buff = New-Item "${basedir}\game" -ItemType Directory -Force;

    #ゲーム複製
    Get-ChildItem $GAME_DIR | ForEach-Object -Process { Copy-Item -Force -Recurse $_.FullName "${basedir}\game\" | Log "複製:${_}から${basedir}\game\"  }

    Log "zipファイル探索ディレクトリ：${basedir}\game"
    $zipfiles = Get-ChildItem "${basedir}\game" -Recurse | Where-Object {$_.Extension -eq ".zip"}
    
    Log "Expand zip files..."
    foreach ($item in $zipfiles){
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
    Remove-Item "${basedir}\bin\${GAME_DIR}\" -Recurse -Force

    NoTimeLog "Zip List"
    foreach ($item in $zipfiles){
        NoTimeLog "${item}"
    }
}else{
    Log "解凍データなし。"
}

Stop-Transcript