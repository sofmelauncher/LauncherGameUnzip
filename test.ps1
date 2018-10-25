function Invoke-DownloadFile{

	[CmdletBinding()]
	param(
		[parameter(Mandatory,position=0)]
		[string]
		$Uri,

		[parameter(Mandatory,position=1)]
		[string]
		$DownloadFolder,

		[parameter(Mandatory,position=2)]
		[string]
		$FileName
	)

	begin
	{
		If (-not(Test-Path $DownloadFolder))
		{
			try
			{
				New-Item -ItemType Directory -Path $DownloadFolder -ErrorAction stop
			}
			catch
			{
				throw $_
			}
		}

		try
		{
			$DownloadPath = Join-Path $DownloadFolder $FileName -ErrorAction Stop
		}
		catch
		{
			throw $_
		}
	}

	process
	{
		Invoke-WebRequest -Uri $Uri -OutFile $DownloadPath -Verbose -PassThru
	}

	end
	{
		Get-Item $DownloadPath
	}

}

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
set LOG_PATH "./Expandlog.log" -option constant

Start-Transcript -path $LOG_PATH -append;

#$basedir = "C:\Users\SAVIO\Desktop\test";
$basedir = (Convert-Path .);

CheckDataBase;

Log "ディレクトリ：${basedir}"
$gomidir = $basedir + "\gomi";
$buff =  New-Item $gomidir -ItemType Directory -Force;
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
Invoke-DownloadFile -Uri "http://sofme.unitech.jp/static/gameregister/file" -DownloadFolder "./"

Stop-Transcript

