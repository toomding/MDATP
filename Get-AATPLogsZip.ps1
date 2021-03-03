Function Get-AATPLogsZip{
$AATPLogsZipName = "AATPLogs.zip"
$AATPLogsPath = (Join-Path -Path ((Get-Service -Name AATPSensor).BinaryPathname.Replace('"','') | Split-Path -Parent) -ChildPath "Logs")
$AATPLogsPathTest = Test-Path -Path $AATPLogsPath
If ($AATPLogsPathTest) { Compress-Archive -Path $AATPLogsPath -DestinationPath $AATPLogsZipName } else { Write-Host "Error, path doesn't exist" }
}
Get-AATPLogsZip