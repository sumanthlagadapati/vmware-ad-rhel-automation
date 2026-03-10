<#
.SYNOPSIS
    Comprehensive Active Directory User Reporting Tool.

.DESCRIPTION
    This script generates a detailed report of AD users, including their status,
    group memberships, last login, and password expiration details.

.EXAMPLE
    .\Get-ADUserReport.ps1 -ExportCSV -FilePath "C:\Reports\ADUsers.csv"

.NOTES
    Requires Active Directory PowerShell module.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [switch]$ExportCSV,

    [Parameter(Mandatory = $false)]
    [string]$FilePath = ".\ADUserReport.csv"
)

try {
    Write-Host "Checking for Active Directory module..." -ForegroundColor Cyan
    if (-not (Get-Module -ListAvailable ActiveDirectory)) {
        throw "Active Directory module not found. Please install RSAT: Active Directory Domain Services & Lightweight Directory Services Tools."
    }

    Write-Host "Fetching user data from domain..." -ForegroundColor Cyan
    $Users = Get-ADUser -Filter * -Properties Enabled, LastLogonDate, PasswordExpired, PasswordLastSet, MemberOf | Select-Object `
        Name,
        SamAccountName,
        Enabled,
        LastLogonDate,
        PasswordExpired,
        PasswordLastSet,
        @{Name='Groups';Expression={$_.MemberOf -replace 'CN=(.+?),(?:OU|DC)=.+','$1' -join '; '}}

    Write-Host "Successfully retrieved $($Users.Count) users." -ForegroundColor Green

    if ($ExportCSV) {
        $Users | Export-Csv -Path $FilePath -NoTypeInformation -Encoding utf8
        Write-Host "Report exported to: $FilePath" -ForegroundColor Green
    } else {
        $Users | Out-GridView -Title "Active Directory User Report"
    }
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    Write-Host "AD Reporting script completed." -ForegroundColor Cyan
}
