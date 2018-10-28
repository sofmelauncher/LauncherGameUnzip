set LOG_FILE "Picture-Regulations.log" -option constant
set CSV_FILE "./picture_data.csv" -option constant

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

$date = (Get-Date -Format "yyyy-MM-dd")
Start-Transcript -path "${date}-${LOG_FILE}" -append;

$basedir = (Convert-Path ../);

Log "pngファイル探索"
$pngfiles = Get-ChildItem "${basedir}\bin\file" -Recurse | Where-Object {$_.Extension -eq ".png"}

Log "jgpeファイル探索"
$jpegfiles = Get-ChildItem "${basedir}\bin\file" -Recurse | Where-Object {$_.Extension -eq ".jpeg"}



$shell=New-Object -Com Shell.Application;

Remove-Item "${CSV_FILE}" -Recurse -Force
Add-Content -path "${CSV_FILE}" -Value '"ディレクトリ","ファイル名","サイズ","幅","高さ",' -Encoding UTF8

foreach ($item in $pngfiles){
    $folderobj = $shell.NameSpace($item.DirectoryName)
    $file = $folderobj.ParseName($item.name)

    $name = $folderobj.GetDetailsOf($file, 0)
    $file_size = $folderobj.GetDetailsOf($file, 1)
    $width= $folderobj.GetDetailsOf($file, 177)
    $height= $folderobj.GetDetailsOf($file, 179)

    $file_path = $item.DirectoryName
    Log "${file_path}"
    Log "[名前]：${name}";
    Log "[サイズ]：${file_size}";
    Log "[幅]：${width}";
    Log "[高さ]：${height}";
    $width = $width -replace "ピクセル", ""
    $height = $height -replace "ピクセル", ""
    Add-Content -path "${CSV_FILE}" -Value "${file_path},${name},${file_size},${width},${height}" -Encoding UTF8

}

foreach ($item in $jpegfiles){
    $folderobj = $shell.NameSpace($item.DirectoryName)
    $file = $folderobj.ParseName($item.name)

    $name = $folderobj.GetDetailsOf($file, 0)
    $file_size = $folderobj.GetDetailsOf($file, 1)
    $width= $folderobj.GetDetailsOf($file, 177)
    $height= $folderobj.GetDetailsOf($file, 179)

    $file_path = $item.DirectoryName
    Log "${file_path}"
    Log "[名前]：${name}";
    Log "[サイズ]：${file_size}";
    Log "[幅]：${width}";
    Log "[高さ]：${height}";
    $width = $width -replace "ピクセル", ""
    $height = $height -replace "ピクセル", ""
    Add-Content -path "${CSV_FILE}" -Value "${file_path},${name},${file_size},${width},${height}" -Encoding UTF8

}
