set LOG_FILE "Movie-Regulations.log" -option constant
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

Log "mp4ファイル探索"
$pngfiles = Get-ChildItem "${basedir}\bin\file" -Recurse | Where-Object {$_.Extension -eq ".png"}

Log "aviファイル探索"
$jpegfiles = Get-ChildItem "${basedir}\bin\file" -Recurse | Where-Object {$_.Extension -eq ".jpeg"}



$shell=New-Object -Com Shell.Application;

Remove-Item "${CSV_FILE}" -Recurse -Force
Add-Content -path "${CSV_FILE}" -Value '"ディレクトリ","ファイル名","サイズ","大きさ",'

foreach ($item in $pngfiles){
    $folderobj = $shell.NameSpace($item.DirectoryName)
    $file = $folderobj.ParseName($item.name)

    $name = $folderobj.GetDetailsOf($file, 0)
    $file_size = $folderobj.GetDetailsOf($file, 1)
    $size = $folderobj.GetDetailsOf($file, 31)

    $file_path = $item.DirectoryName
    Log "${file_path}"
    Log "[名前]：${name}";
    Log "[サイズ]：${file_size}";
    Log "[大きさ]：${size}";
    Add-Content -path "${CSV_FILE}" -Value "${file_path}, ${name}, ${file_size}, ${size}"

}

foreach ($item in $jpegfiles){
    $folderobj = $shell.NameSpace($item.DirectoryName)
    $file = $folderobj.ParseName($item.name)

    $name = $folderobj.GetDetailsOf($file, 0)
    $file_size = $folderobj.GetDetailsOf($file, 1)
    $size = $folderobj.GetDetailsOf($file, 31)

    $file_path = $item.DirectoryName
    Log "${file_path}"
    Log "[名前]：${name}";
    Log "[サイズ]：${file_size}";
    Log "[大きさ]：${size}";
    Add-Content -path "${CSV_FILE}" -Value "${file_path}, ${name}, ${file_size}, ${size}"

}
