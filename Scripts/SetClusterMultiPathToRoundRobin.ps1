<#
 Script name: SetClusterMultiPathToRoundRobin.ps1
 Created on: 09/14/2017
 Author: Alan Comstock, @Mr_Uptime
 Description: Set the MultiPath policy for FC devices to RoundRobin for all hosts in a cluster.
 Dependencies: None known
 PowerCLI Version: VMware PowerCLI 6.5 Release 1 build 4624819
 PowerShell Version: 5.1.14393.1532
 OS Version: Windows 10
#>

#Set the Multipathing Policy to Round Robin and IOPS to 1 for all fibre channel 3Par disks. This is an HPE best practice.
$pathpolicy="RoundRobin"
$iops="1"
$vendor="3PARdata"
$AllESXHosts = Get-VMHost -Location CLUSTERNAME | Sort Name
Foreach ($esxhost in $AllESXHosts) {
	Write-Host "Working on" $esxhost
	$scsilun = Get-VMhost $esxhost | Get-VMHostHba -Type "FibreChannel" | Get-ScsiLun -LunType disk | Where-Object {$_.Vendor -like $vendor -and ($_.MultipathPolicy -notlike $pathpolicy -or $_.CommandsToSwitchPath -ne $iops)}
	if ($scsilun -ne $null){
	Set-ScsiLun -ScsiLun $scsilun -MultipathPolicy $pathpolicy -CommandsToSwitchPath $iops
	}
}
#The End
