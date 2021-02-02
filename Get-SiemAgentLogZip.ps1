Function Get-SiemAgentLogZip{
$SiemTempFolder="$HOME\SiemTemp"
$SiemZipLogName="sime-agent.zip"
$Rawoutput=(Get-Process -Name Java)
$TotalVar= $Rawoutput | Select-Object id,name,commandline
$TotalAmount=($TotalVar | Measure-Object).Count
New-Item -Type Directory -Path $SiemTempFolder | Out-Null
foreach ($i in $Rawoutput) 
{if ($i.CommandLine.Contains('siem')) {$SiemLogPath = (($i.CommandLine).split('--logsDirectory '))[1].split(' --token')[0] } else {Write-Host "Didn't find any siem agent running"}}
Write-Host "Begin Search for SIEM agent"
Write-Host "Find $TotalAmount java process"
Write-Host "Begin Search for matched process"
Write-Host "The siem agent logs location is $SiemLogPath"
Copy-Item -Recurse -Path $SiemLogPath -Destination $SiemTempFolder
Compress-Archive -Path $SiemTempFolder  -DestinationPath ./sime-agent.zip -CompressionLevel Fastest
Remove-Item -Recurse -Force -Path $SiemTempFolder
$SiemLogZipFullName=(Get-ChildItem $HOME | ? {$_.Name -eq $SiemZipLogName}).FullName
Write-Host "The logs have be successfully generated and it is in this foler $SiemLogZipFullName Please upload it for analysis"
}
Get-SiemAgentLogZip