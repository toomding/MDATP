<#
Get this pc's asr status.
At least one ASR has status, it shouldn't be null.

Version 1.0
By TomDing

#>
<# Define ASRID HashTable #>
$ASRID_HashTable = @{
	"01443614-CD74-433A-B99E-2ECDC07BFC25" = "Block executable files from running unless they meet a prevalence, age, or trusted list criterion";
	"BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" = "Block executable content from email client and webmail                                           ";
	"D4F940AB-401B-4EFC-AADC-AD5F3C50688A" = "Block all Office applications from creating child processes                                      ";
	"3B576869-A4EC-4529-8536-B80A7769E899" = "Block Office applications from creating executable content                                       ";
	"75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" = "Block Office applications from injecting code into other processes                               ";
	"D3E037E1-3EB8-44C8-A917-57927947596D" = "Block JavaScript or VBScript from launching downloaded executable content                        ";
	"5BEB7EFE-FD9A-4556-801D-275E5FFC04CC" = "Block execution of potentially obfuscated scripts                                                ";
	"92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B" = "Block Win32 API calls from Office macros                                                         ";
	"c1db55ab-c21a-4637-bb3f-a12568109d35" = "Use advanced protection against ransomware                                                       ";
	"9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2" = "Block credential stealing from the Windows local security authority subsystem (lsass.exe)        ";
	"d1e49aac-8f56-4280-b9ba-993a6d77406c" = "Block process creations originating from PSExec and WMI commands                                 ";
	"b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4" = "Block untrusted and unsigned processes that run from USB                                         ";
	"26190899-1602-49e8-8b27-eb1d0a1ce869" = "Block Office communication application from creating child processes                             ";
	"7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c" = "Block Adobe Reader from creating child processes                                                 ";
	"e6db77e5-3df2-4cf1-b95a-636979351e5b" = "Block persistence through WMI event subscription                                                 ";
	"56a863a9-875e-4185-98a7-b882c64b5ce5" = "Block abuse of exploited vulnerable signed drivers                                               "
}
<# Define ASR Status HashTable #>
$ASRStatus_HashTable = @{
	"0" = "Disabled";
	"1" = "Enabled ";
	"2" = "Audit   ";
        "6" = "Warn    "
}
<# Define Get Asr Status Function #>
Function Get-AsrStatus {
$ASRRules = (Get-MpPreference).AttackSurfaceReductionRules_Ids
$ASRActions = (Get-MpPreference).AttackSurfaceReductionRules_Actions
$ae= $ASRActions.GetEnumerator()
$be= $ASRRules.GetEnumerator()
$counter=0
$disabledCounter=0
$enabledCounter=0
$auditCounter=0
$warnCounter=0
Write-Host "                  " "Asr ID" "                 " "Asr Status code" "           "  "Asr Status" "         " "Asr Description" "                                                                                     "  "SN"
Write-Host "     --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
while ($ae.MoveNext() -and $be.MoveNext()) {
	$counter=$counter+1
	$AsrID=$be.Current
	$AsrStatusCode=$ae.Current
	$AsrStatus=$ASRStatus_HashTable.($ae.Current.ToString())
	$AsrDescription=$ASRID_HashTable.($be.Current)
	Write-Host "    " $AsrID "       "$AsrStatusCode "                   " $AsrStatus "           "  $AsrDescription  "    " $counter
	if($AsrStatusCode -eq 0){
		$disabledCounter=$disabledCounter+1
	} elseif($AsrStatusCode -eq 1){
		$enabledCounter=$enabledCounter+1
        } elseif($AsrStatusCode -eq 6){
                $warnCounter=$warnCounter+1
        } else {
		$auditCounter=$auditCounter+1
	}
}
$AsrNotConfigured= (16 - $disabledCounter - $enabledCounter - $auditCounter -$warnCounter)
Write-Host "     --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
Write-Host "    " "Disabled Asr rule in total is :" $disabledCounter ";" "Enabled Asr rule in total is  :" $enabledCounter ";" "Audited Asr rule in total is  :" $auditCounter ";" "Warn Asr rule in total is  :" $warnCounter "."
Write-Host "    " "Not Configured rule in total is : " $AsrNotConfigured ";" "There are" $counter " rules presented in system."
}
<# Run this function #>
Get-AsrStatus
