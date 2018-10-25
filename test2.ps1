#function Log($text){
    #$time = Get-Data;
    #Write-Output "${time}${text}";
#}

set LOG_PATH "./Expandlog.log" -option constant

Start-Transcript -path $LOG_PATH -append;

#$basedir = "C:\Users\SAVIO\Desktop\test";
$basedir = (Convert-Path .);


$gomidir = $basedir + "\gomi";
New-Item $gomidir -ItemType Directory -Force;
Write-Host "Search zip files..."
$zipfiles = Get-ChildItem $basedir -Recurse | Where-Object {$_.Extension -eq ".zip"}
 
Write-Host "Expand zip files..."
foreach ($item in $zipfiles){
    Write-Host $item.Name -ForegroundColor Green

    $destination = $item.FullName;
    $destination = $destination.Substring(0, $destination.Length - ($item.Extension).Length);
    $buffer = New-Item -Path $destination -ItemType Directory
 
    #Expand-Archive -Path $item.FullName -DestinationPath $destination
    #Move-Item $item.FullName $gomidir;
}
Stop-Transcript

