# Import Active Directory module
Import-Module ActiveDirectory

# Define CSV file path (Located on Desktop)
$CSVFilePath = "C:\Users\JDoe\Desktop\Azure-Lab\user_accounts_final.csv"

# Ensure log directory exists
$LogDirectory = "C:\temp\"
if (!(Test-Path -Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory
}

# Define log file
$LogFile = "$LogDirectory\ADUserImportLog.txt"
Write-Output "---- Script Execution Started $(Get-Date) ----" | Out-File -Append $LogFile

# Check if CSV file exists
if (!(Test-Path -Path $CSVFilePath)) {
    Write-Warning "CSV file not found at $CSVFilePath. Please ensure it is in the correct location."
    Write-Output "Error: CSV file not found - $(Get-Date)" | Out-File -Append $LogFile
    exit
}

# Import users from CSV
$ADUsers = Import-Csv -Path $CSVFilePath

# Extract unique OUs from the CSV file
$OUs = $ADUsers | Select-Object -ExpandProperty OU -Unique

# Create OUs if they do not exist
foreach ($OU in $OUs) {
    if (-not (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $OU})) {
        Write-Host "Creating OU: $OU"
        New-ADOrganizationalUnit -Name ($OU -split ",")[0].Replace("OU=", "") -Path "DC=myazurelab,DC=com" -ProtectedFromAccidentalDeletion $false
        Write-Output "Created OU: $OU - $(Get-Date)" | Out-File -Append $LogFile
    }
    else {
        Write-Output "OU already exists: $OU - $(Get-Date)" | Out-File -Append $LogFile
    }
}

# Loop through each user in CSV
foreach ($User in $ADUsers) {
    # Assign variables from CSV
    $DisplayName = $User.DisplayName
    $Username = $User.username
    $Password = $User.password
    $Firstname = $DisplayName.Split(" ")[0]
    $Lastname = $DisplayName.Split(" ")[1]
    $Email = $User.email
    $UPN = $User.UPN
    $OU = $User.OU
    $Company = $User.company
    $Department = $User.department
    $StreetAddress = $User.streetaddress
    $City = $User.city
    $Zipcode = $User.zipcode
    $State = $User.state
    $Country = $User.country
    $Telephone = $User.telephone
    $JobTitle = $User.jobtitle

    # Validate that the assigned OU exists before adding users
    if (-not (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $OU})) {
        Write-Warning "Skipping user $Username because OU $OU does not exist."
        Write-Output "Error: OU $OU not found for user $Username - $(Get-Date)" | Out-File -Append $LogFile
        continue
    }

    # Check if user already exists
    if (Get-ADUser -Filter {SamAccountName -eq $Username}) {
        Write-Warning "User $Username already exists in AD."
        Write-Output "User $Username already exists - $(Get-Date)" | Out-File -Append $LogFile
    }
    else {
        try {
            # Create AD user
            New-ADUser `
                -SamAccountName $Username `
                -UserPrincipalName $UPN `
                -Name "$Firstname $Lastname" `
                -GivenName $Firstname `
                -Surname $Lastname `
                -Enabled $True `
                -DisplayName "$Firstname $Lastname" `
                -Path $OU `
                -Company $Company `
                -Department $Department `
                -EmailAddress $Email `
                -StreetAddress $StreetAddress `
                -City $City `
                -State $State `
                -PostalCode $Zipcode `
                -Country $Country `
                -OfficePhone $Telephone `
                -Title $JobTitle `
                -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
                -ChangePasswordAtLogon $False

            Write-Output "User $Username created successfully - $(Get-Date)" | Out-File -Append $LogFile
        }
        catch {
            Write-Warning "Failed to create user $Username. Error: $_"
            Write-Output "Error creating user $Username - $_ - $(Get-Date)" | Out-File -Append $LogFile
        }
    }
}

Write-Output "---- Script Execution Completed $(Get-Date) ----" | Out-File -Append $LogFile

