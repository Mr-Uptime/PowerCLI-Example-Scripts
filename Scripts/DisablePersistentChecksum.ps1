<#
 Script name: DisablePersistentChecksum.ps1
 Created on: 12/14/2017
 Author: Alan Comstock, @Mr_Uptime
 Description: Disables persistent checksum for host bus adapters in a cluster.  Created to be used with Emulex 16gb fibre channel adapters.  See HPE customer advisory for more details.  https://support.hpe.com/hpsc/doc/public/display?docId=emr_na-c05348035
 Dependencies: None known
 PowerCLI Version: VMware PowerCLI 6.5 Release 1 build 4624819
 PowerShell Version: 5.1.14393.1532
 OS Version: Windows 10
#>


$AllESXHosts = Get-VMHost -Location CLUSTERNAME | Sort Name
Foreach ($esxhost in $AllESXHosts)
{
	Write-Host $esxhost
	Get-VMHost $esxhost | Get-VMHostModule lpfc | Set-VMhostModule -Options "lpfc_external_dif=0"
}
