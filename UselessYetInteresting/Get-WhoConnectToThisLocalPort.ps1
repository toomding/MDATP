<#
Get-WhoISConnectToThisLocalPort

By Tom.Ding
#>
param ($RemotePort)
Function Get-WhoISConnectToThisLocalPort ($RemotePort){
    if ((Get-NetTCPConnection -RemotePort $RemotePort -ErrorAction SilentlyContinue )){
        $ProcessPid=((Get-NetTCPConnection -State Established -RemotePort $RemotePort).OwningProcess | Sort-Object -Unique)
        ForEach ($PPid in $ProcessPid) {
            $ProcessOutputs = (Get-Process -PID $PPid | Select-Object -Property Id,ProcessName)
            $ProcessOutputs
    }
}
    else {
        Write-Host "The Port $RemotePort doesn't exits on system"
    }
}
Get-WhoISConnectToThisLocalPort -RemotePort 7890
<#
Issue #1:
Fixed State of Established, Can't use other state like closed, syn etc.
Reason #1:
Established state is main focus of this script, temporaily ignore other status.
#>
<#
Deprecated Code:
$MainOutputCollection=@()
$MainOutput = "" | Select-Object Id,ProcessName,State
$ConnectionOutputs = ((Get-NetTCPConnection -OwningProcess $PPID -RemotePort 7890).State | Sort-Object -Unique)
$MainOutput.Id = $ProcessOutputs.Id
$MainOutput.ProcessName = $ProcessOutputs.ProcessName
$MainOutput.State = $ConnectionOutputs
$MainOutputCollection += $MainOutput
#>