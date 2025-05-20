# Define variables
$serviceAccount = "BADCLOUDNL\#sa_helloid"
$usersTargetOU = "OU=Users,OU=test-perm-script,OU=Tenants,DC=bad-cloud,DC=nl"
$groupsTargetOU = "OU=Groups,OU=test-perm-script,OU=Tenants,DC=bad-cloud,DC=nl"

# Helper function for running Grant-Permission with error handling
function Grant-Permission {
    param (
        [string]$OU,
        [string]$Permission
    )

    try {
        dsacls $OU /I:S /G $Permission | Out-Null
        Write-Host "Granted: $Permission"
    } catch {
        Write-Warning "Failed to grant permission: $Permission"
        Write-Warning "Error: $_"
    }
}

# Delegate permissions using Grant-Permission
Write-Host "Assigning full user and group permissions to $($serviceAccount) on $targetOU..."

# --- User Object Permissions ---

# Create and delete user objects
Grant-Permission -OU $usersTargetOU -Permission "$($serviceAccount):CCDC;user"
##### Grant-Permission $usersTargetOU -Permission "$($serviceAccount):DC;user"

# Read and write all user attributes
Grant-Permission -OU $usersTargetOU -Permission "$($serviceAccount):RPWP;user"

# Password and account management
Grant-Permission -OU $usersTargetOU -Permission "$($serviceAccount):CA;Reset Password;user"
Grant-Permission -OU $usersTargetOU -Permission "$($serviceAccount):WP;pwdLastSet"
Grant-Permission -OU $usersTargetOU -Permission "$($serviceAccount):WP;userAccountControl"
Grant-Permission -OU $usersTargetOU -Permission "$($serviceAccount):WP;accountExpires"

# --- Group Object Permissions ---

# Create group objects
Grant-Permission -OU $groupsTargetOU -Permission "$($serviceAccount):CC;group"

##### Delete group objects
##### Grant-Permission $groupsTargetOU -Permission "$($serviceAccount):DC;group"

# Read and write all group attributes
Grant-Permission -OU $groupsTargetOU -Permission "$($serviceAccount):RPWP;group"

# Modify group membership
Grant-Permission -OU $groupsTargetOU -Permission "$($serviceAccount):WP;member"

# --- Local Administrator Group Membership ---

try {
    $group = [ADSI]"WinNT://./Administrators,group"
    $group.Add("WinNT://$serviceAccount")
    Write-Host "Service account $serviceAccount added to local Administrators group."
} catch {
    Write-Warning "Failed to add $serviceAccount to local Administrators group."
    Write-Warning "Error: $_"
}

Write-Host "Permissions assigned completed."
