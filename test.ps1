﻿set LOG_FILE "Expandlog.log" -option constant
set DOWNLOAD_URI "http://sofme.unitech.jp/static/gameregister/file" -option constant
set DOWNLOAD_FILE "sofme.unitech.jp/static/gameregister/file" -option constant
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

$basedir = (Convert-Path ../);

CheckDataBase;

Log "ランチャールートディレクトリ：${basedir}"
$gomi_zip = $basedir + "/gomi_zip";
$gomi_index = $basedir + "/gomi_index";

Log "ディスク作成:${gomi_zip}"
$buff =  New-Item $gomi_zip -ItemType Directory -Force;
Log "ディスク作成:${gomi_index}"
$buff =  New-Item $gomi_index -ItemType Directory -Force;

Log "データダウンロード"
#./bin/wget.exe -r $DOWNLOAD_URI
#Move-Item $DOWNLOAD_FILE "../game";

#ゴミファイル削除
Get-ChildItem $basedir -include  *.html* -r | ForEach-Object -Process { Remove-Item $_ | Log "削除:${_}"  }
Log "ダウンロードディレクトリ削除:${basedir}/bin/${DOWNLOAD_DOMAIN}"
Remove-Item "${basedir}/bin/${DOWNLOAD_DOMAIN}"

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

NoTimeLog "Zip List"
foreach ($item in $zipfiles){
    NoTimeLog "${item}"
}

Stop-Transcript

