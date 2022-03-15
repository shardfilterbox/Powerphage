Connect-ExchangeOnline
Connect-AzureAD
Install-Module ExchangeOnlineManagement

##Variables
#Get information for filename
$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$DownloadsFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$TenantDetails = Get-AzureADTenantDetail
$TenantName = $TenantDetails.DisplayName

#Export and open
Get-Mailbox | Select-Object UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward | Export-csv $DownloadsFolder\$TenantName-MailboxForwarding-$CurrentDate.csv -NoTypeInformation
Start-Process $DownloadsFolder\$TenantName-MailboxForwarding-$CurrentDate.csv

Disconnect-ExchangeOnline -Confirm:$false