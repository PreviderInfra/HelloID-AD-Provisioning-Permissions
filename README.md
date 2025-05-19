# HelloID Service Account Permissions for Active Directory Provisioning

This document describes the required permissions for the HelloID Provisioning **service account** in Active Directory (AD), and how to assign them securely.

---

## 🔧 Overview

The HelloID service account must have **delegated permissions** on specific Organizational Units (OUs) to:

### User Object Permissions
- Read and write user objects
- Create and delete users
- Modify attributes
- Reset passwords and control accounts

### Group Object Permissions
- Read and write group objects
- Create groups
- Modify attributes
- Manage group membership

> 🛡️ These permissions should **not** be granted at the domain level — use **least privilege** principles.

---

## 🔐 Required Permissions

| Object Type | Permissions | Purpose |
|-------------|-------------|---------|
| User | Create/Delete, Read/Write all attributes, Reset Password, Account Control | Provisioning and lifecycle management |
| Group | Create/Delete, Read/Write all attributes, Modify membership | Group management for access and roles |

---

## ⚙️ Delegation Method

### ✅ Recommended: PowerShell Script
Use `dsacls.exe` to grant granular permissions to a service account on a specific OU.

### 🔧 Example:
```powershell
dsacls "OU=Users,OU=HR,DC=example,DC=com" /I:T /G "HELLOID\SVC_HelloID:RPWP;user"
```

> This grants **Read/Write all properties** on user objects in the specified OU.

---

## 📁 OU Scope

Assign permissions **only to the OUs** where HelloID needs to manage users and groups.

- `OU=Users,OU=Departments,DC=example,DC=com`
- `OU=Groups,OU=Departments,DC=example,DC=com`

---

## ⚠️ Security Best Practices

- ❌ **DO NOT** make the service account a Domain Admin
- ✅ Grant only the required permissions
- 🧪 Test in a staging OU before applying in production
- 🔐 Use a strong password and consider using a managed service account (gMSA) if supported

---

## 📘 References

- [HelloID Provisioning Documentation](https://docs.helloid.com)
- [Microsoft dsacls Documentation](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/dsacls)
