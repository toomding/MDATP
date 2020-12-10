<#
Av Status Fetcher
Attention: As long as the Defender is not primary software, regardless it is in passive mode or PxP mode. it will all show disabled.
By Tom.Ding
#>
Function Get-AvStatusFetcher {
    $AvStatus=(Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct | Select-Object productState | ForEach-Object { [System.String]::Format('{0:X}', $_.productState)});$AvName=Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct | Select-Object displayName ;$counter=-1;$seq=0
    $AvStatus | ForEach-Object {
        $counter=$counter+1
        $seq=$seq+1
        $CompareVar = [string]$_
        if ($CompareVar[-2] -eq "1" -and $CompareVar[-4] -eq "0" )
        {
            Write-Host $seq " : " $AvName[$counter].displayName "is out of date and disabled."
        }
        elseif ($CompareVar[-2] -eq "0" -and $CompareVar[-4] -eq "1" )
        {
            Write-Host $seq " : " $AvName[$counter].displayName "is up to date and enabled."
        }
        elseif ($CompareVar[-2] -eq "1" -and $CompareVar[-4] -eq "1")
        {
            Write-Host $seq " : " $AvName[$counter].displayName "is out of date and enabled."
        }
       elseif ($CompareVar[-2] -eq "0" -and $CompareVar[-4] -eq "0")
       {
            Write-Host $seq " : " $AvName[$counter].displayName "is up to date but disabled."
       }
       else {
           Write-Host "Didn't find any matched"
       }
       }
    if ($seq -ge 2) { Write-Host "There are total $seq Av softwares presented on this system." } else { Write-Host "There is 1 Av Software presented on this system."}
    }
Get-AvStatusFetcher
