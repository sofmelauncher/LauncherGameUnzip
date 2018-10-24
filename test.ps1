function Log($text){
    $time = (Get-Date -Format 'yyyy/MM/dd-HH:mm:ss.fff')
    Write-Output "[${time}] : ${text}";
}

function NoTimeLog($text){
    Write-Output "${text}";
}
set LOG_PATH "./Expandlog.log" -option constant

Start-Transcript -path $LOG_PATH -append;

#$basedir = "C:\Users\SAVIO\Desktop\test";
$basedir = (Convert-Path .);

Log("ディレクトリ：${basedir}");
$gomidir = $basedir + "\gomi";
New-Item $gomidir -ItemType Directory -Force;
Log("Search zip files...");
$zipfiles = Get-ChildItem $basedir -Recurse | Where-Object {$_.Extension -eq ".zip"}
    
Log("Expand zip files...");
foreach ($item in $zipfiles){
    $destination = $item.FullName;
    $destination = $destination.Substring(0, $destination.Length - ($item.Extension).Length);
    Log("[Destination] ${destination}")
    #$buffer = New-Item -Path $destination -ItemType Directory
    Log("[Expand] ${item}");
    #Expand-Archive -Path $item.FullName -DestinationPath $destination
    Log("[Move-Item] ${item}");
    #Move-Item $item.FullName $gomidir;
}

NoTimeLog("Zip List");
foreach ($item in $zipfiles){
    NoTimeLog("${item}");
}


Stop-Transcript

