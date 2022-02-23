Connect-AzureAD

$ObjectId = Read-Host -Prompt "Input Object ID"
Get-AzureADObjectByObjectId -ObjectIds $ObjectId