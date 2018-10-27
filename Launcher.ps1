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

function CheckDataBase(){
    $result = (Test-Path "./db.sqlite3")
    if($result){
        Log "DB OK"
    }else{
        Log "DBが存在しません" 2
    } 
}
$date = (Get-Date -Format "yyyy-MM-dd")
Start-Transcript -path "${date}-${LOG_FILE}" -append;

$basedir = (Convert-Path ../);

Log "ランチャールートディレクトリ：${basedir}"
$game_zip = $basedir + "\gomi_zip";

Log "ディレクトリ作成:${game_zip}"
$buff = New-Item $game_zip -ItemType Directory -Force;
Log "ディレクトリ作成:${basedir}\game"
$buff = New-Item "${basedir}\game" -ItemType Directory -Force;

#ゲーム複製
Get-ChildItem $GAME_DIR | ForEach-Object -Process { Copy-Item -Force -Recurse $_.FullName "${basedir}\game\" | Log "複製:${_}から${basedir}\game\"  }

Log "ダウンロードディレクトリ削除:${basedir}\bin\${DOWNLOAD_DOMAIN}"


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
    Move-Item $item.FullName $game_zip;
}
#元ゲームデータ削除
#Remove-Item "${basedir}\bin\${GAME_DIR}\" -Recurse -Force

CheckDataBase
NoTimeLog "Zip List"
foreach ($item in $zipfiles){
    NoTimeLog "${item}"
}

Stop-Transcript