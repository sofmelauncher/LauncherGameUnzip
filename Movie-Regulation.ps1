. ".\Log.ps1"


Set-Variable LOG_FILE "Movie-Regulations.log" -option constant
Set-Variable CSV_FILE "./movie_data.csv" -option constant

$date = (Get-Date -Format "yyyy-MM-dd")
Start-Transcript -path "${date}-${LOG_FILE}" -append;

$basedir = (Convert-Path ../);

Log "mp4ファイル探索"
$mp4files = Get-ChildItem "${basedir}\bin\file" -Recurse | Where-Object { $_.Extension -eq ".mp4" } 

Log "aviファイル探索"
$avifiles = Get-ChildItem "${basedir}\bin\file" -Recurse | Where-Object { $_.Extension -eq ".avi" }



$shell = New-Object -Com Shell.Application;

Remove-Item "${CSV_FILE}" -Recurse -Force
Add-Content -path "${CSV_FILE}" -Value '"ディレクトリ","ファイル名","サイズ","長さ","総ビットレート","フレーム幅","フレーム高","フレーム率"' -Encoding UTF8

foreach ($item in $mp4files) {
    $folderobj = $shell.NameSpace($item.DirectoryName)
    $file = $folderobj.ParseName($item.name)

    $name = $folderobj.GetDetailsOf($file, 0)
    $file_size = $folderobj.GetDetailsOf($file, 1)
    $length = $folderobj.GetDetailsOf($file, 27)
    $bit_rate = $folderobj.GetDetailsOf($file, 321)
    $width = $folderobj.GetDetailsOf($file, 317)
    $heigh = $folderobj.GetDetailsOf($file, 315)
    $frame_rate = $folderobj.GetDetailsOf($file, 316)

    $file_path = $item.DirectoryName
    Log "${file_path}"
    Log "[名前]：${name}";
    Log "[サイズ]：${file_size}";
    Log "[長さ]：${length}";
    Log "[ビットレート]：${bit_rate}";
    Add-Content -path "${CSV_FILE}" -Value "${file_path}, ${name}, ${file_size}, ${length}, ${bit_rate}, ${width}, ${heigh}, ${frame_rate}" -Encoding UTF8

}
foreach ($item in $avifiles) {
    $folderobj = $shell.NameSpace($item.DirectoryName)
    $file = $folderobj.ParseName($item.name)

    $name = $folderobj.GetDetailsOf($file, 0)
    $file_size = $folderobj.GetDetailsOf($file, 1)
    $length = $folderobj.GetDetailsOf($file, 27)
    $bit_rate = $folderobj.GetDetailsOf($file, 321)
    $width = $folderobj.GetDetailsOf($file, 317)
    $heigh = $folderobj.GetDetailsOf($file, 315)
    $frame_rate = $folderobj.GetDetailsOf($file, 316)

    $file_path = $item.DirectoryName
    Log "${file_path}"
    Log "[名前]：${name}";
    Log "[サイズ]：${file_size}";
    Log "[長さ]：${length}";
    Log "[ビットレート]：${bit_rate}";
    Add-Content -path "${CSV_FILE}" -Value "${file_path}, ${name}, ${file_size}, ${length}, ${bit_rate}, ${width}, ${heigh}, ${frame_rate}" -Encoding UTF8

}
