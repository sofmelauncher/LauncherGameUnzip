﻿set LOG_FILE "Expandlog.log" -option constant
set DOWNLOAD_URI "http://sofme.unitech.jp/static/gameregister/games.zip" -option constant
set DOWNLOAD_FILE "sofme.unitech.jp/static/gameregister/file/" -option constant
set DOWNLOAD_DOMAIN "sofme.unitech.jp" -option constant

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

$basedir = (Cgameregister.GameInfo.tag: (fields.W340) null has no effect on ManyToManyField.onvert-Path ../);

Log "ランチャールートディレクトリ：${basedir}"
$game_zip = $basedir + "/gomi_zip";d2

Log "ディスク作成:${game_zip}"
$buff = New-Item $game_zip -ItemType Directory -Force;
Log "ディスク作成:${basedir}\game"
$buff = New-Item ${basedir}\game -ItemType Directory -Force;

$id = 0
$buff = ""
if($args.Length -ne 0){
   foreach($arg in $args){
        $buff = [int]::TryParse($arg,[ref]$id)
        Log "${id}のデータダウンロード"
        ./bin/wget.exe --restrict-file-names=nocontrol -r "${DOWNLOAD_URI}/${id}"
    }
}else{
    Log "全ゲームデータダウンロード"
    ./bin/wget.exe --restrict-file-names=nocontrol  -r $DOWNLOAD_URI
}

#ゴミファイル削除
Get-ChildItem $basedir -include  *.html* -Recurse | ForEach-Object -Process { Remove-Item $_ | Log "削除:${_}"  }

#ゲーム移動
Get-ChildItem $DOWNLOAD_FILE | ForEach-Object -Process { Copy-Item -Force -Recurse $_.FullName "${basedir}\game\" | Log "移動:${_}から${basedir}\game\"  }

Log "ダウンロードディレクトリ削除:${basedir}\bin\${DOWNLOAD_DOMAIN}"
Remove-Item "${basedir}\bin\${DOWNLOAD_DOMAIN}" -Recurse -Force

Log "Search zip files..."
$zipfiles = Get-ChildItem $basedir -Recurse | Where-Object {$_.Extension -eq ".zip"}
    
Log "Expand zip files..."
foreach ($item in $zipfiles){
    $destination = $item.FullName;
    $destination = $destination.Substring(0, $destination.Length - ($item.Extension).Length);
    Log "[Destination] ${destination}"
    #$buffer = New-Item -Path $destination -ItemType Directory
    Log "[Expand] ${item}"
    #Expand-Archive -Path $item.FullName -DestinationPath $destination
    Log "[Move-Item] ${item}"
    #Move-Item $item.FullName $gomidir;
}

CheckDataBase
NoTimeLog "Zip List"
foreach ($item in $zipfiles){
    NoTimeLog "${item}"
}

Stop-Transcript