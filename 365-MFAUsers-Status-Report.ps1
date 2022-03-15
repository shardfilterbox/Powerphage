Connect-MsolService

## Pull data
$Users = Get-MsolUser -All | ? { $_.UserType -ne "Guest" }
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file

##Some code for testing
#$IsLicensed = $User.IsLicensed
#Write-Output $User.IsLicensed
#Write-Output $users | Export-Csv .\User.csv
#Start .\User.csv

ForEach ($User in $Users) {
    $MFAMethods = $User.StrongAuthenticationMethods.MethodType
    $MFAEnforced = $User.StrongAuthenticationRequirements.State
    $MFAPhone = $User.StrongAuthenticationUserDetails.PhoneNumber
    $DefaultMFAMethod = ($User.StrongAuthenticationMethods | ? { $_.IsDefault -eq "True" }).MethodType
    If (($MFAEnforced -eq "Enforced") -or ($MFAEnforced -eq "Enabled")) {
        Switch ($DefaultMFAMethod) {
            "OneWaySMS" { $MethodUsed = "One-way SMS" }
            "TwoWayVoiceMobile" { $MethodUsed = "Phone call verification" }
            "PhoneAppOTP" { $MethodUsed = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $MethodUsed = "Authenticator app" }
        }
    }
    Else {
        $MFAEnforced = "Not Enabled"
        $MethodUsed = "MFA Not Used" 
    }
  
    $ReportLine = [PSCustomObject] @{
        User        = $User.UserPrincipalName
        IsLicensed  = $User.IsLicensed
        BlockCredential = $User.BlockCredential
        Name        = $User.DisplayName
        MFAUsed     = $MFAEnforced
        MFAMethod   = $MethodUsed 
        PhoneNumber = $MFAPhone
    }
                 
    $Report.Add($ReportLine) 
}


##Some code for testing
#$CurrentDateTime=Get-Date -UFormat "%Y_%m_%d"
#$Report | Sort Name | Export-CSV -Path ".\MFAUsers-Status-Report-$CurrentDateTime.csv"
#start ".\MFAUsers-Status-Report-$CurrentDateTime.csv"


#Get information for filename
$CurrentDate = Get-Date
$CurrentDate = $CurrentDate.ToString('MM-dd-yyyy_hh-mm-ss')
$DownloadsFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$TenantDetails = Get-AzureADTenantDetail
$TenantName = $TenantDetails.DisplayName

#Export and open
$Report | Sort Name | Export-Csv -Path "$DownloadsFolder\$TenantName-MFAUsers-Status-Report-$CurrentDate.csv"
start "$DownloadsFolder\$TenantName-MFAUsers-Status-Report-$CurrentDate.csv"
