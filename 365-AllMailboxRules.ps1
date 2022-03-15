##Connect
Connect-ExchangeOnline
Connect-AzureAD

##Variables
#Get information for filename
$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$DownloadsFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$TenantDetails = Get-AzureADTenantDetail
$TenantName = $TenantDetails.DisplayName

$users = (get-mailbox -RecipientTypeDetails userMailbox -ResultSize unlimited ).UserPrincipalName
foreach ($user in $users) {
    $rules=Get-InboxRule -Mailbox $user 
    if($rules.length -gt '0') {
        $rules | Export-Csv $DownloadsFolder\$TenantName-MailboxRules-$CurrentDate.csv -NoTypeInformation
    }
}

Start $DownloadsFolder\$TenantName-MailboxRules-$CurrentDate.csv