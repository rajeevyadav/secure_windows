#docs
class secure_windows::lgpo {


  # V-73735
  # The Act as part of the operating system user right must not be assigned to any groups or accounts.
  local_security_policy { 'Act as part of the operating system':
    ensure         => 'absent',
  }

  # V-73737
  # The Add workstations to domain user right must only be assigned to the Administrators group.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Add workstations to domain':
      ensure         => 'present',
      policy_setting => 'SeMachineAccountPrivilege',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-544',
    }
  }

  # V-73739
  # The Allow log on locally user right must only be assigned to the Administrators group.
  local_security_policy { 'Allow log on locally':
    ensure         => 'present',
    policy_setting => 'SeInteractiveLogonRight',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73741
  # The Allow log on through Remote Desktop Services user right must only be assigned to the Administrators group.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Allow log on through Remote Desktop Services':
      ensure         => 'present',
      policy_setting => 'SeRemoteInteractiveLogonRight',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-544',
    }
  }

  # V-73743
  # The Back up files and directories user right must only be assigned to the Administrators group.
  local_security_policy { 'Back up files and directories':
    ensure         => 'present',
    policy_setting => 'SeBackupPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73745
  # The Create a pagefile user right must only be assigned to the Administrators group.
  local_security_policy { 'Create a pagefile':
    ensure         => 'present',
    policy_setting => 'SeCreatePagefilePrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73747
  # The Create a token object user right must not be assigned to any groups or accounts.
  local_security_policy { 'Create a token object':
    ensure         => 'absent',
  }

  # V-73749
  # The Create global objects user right must only be assigned to Administrators, Service, Local Service, and Network Service.
  local_security_policy { 'Create global objects':
    ensure         => 'present',
    policy_setting => 'SeCreateGlobalPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6',
  }

  # V-73751
  # The Create permanent shared objects user right must not be assigned to any groups or accounts.
  local_security_policy { 'Create permanent shared objects':
    ensure         => 'absent',
  }

  # V-73753
  # The Create symbolic links user right must only be assigned to the Administrators group.
  if ($facts['windows_role'] and
      $facts['windows_role'] =~ /(^20|,20,|,20$)/) {
    local_security_policy { 'Create symbolic links':
      ensure         => 'present',
      policy_setting => 'SeCreateSymbolicLinkPrivilege',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-544,*S-1-5-83-0',
    }
  }
  else {
    local_security_policy { 'Create symbolic links':
      ensure         => 'present',
      policy_setting => 'SeCreateSymbolicLinkPrivilege',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-544',
    }
  }

  # V-73755
  # The Debug programs user right must only be assigned to the Administrators group.
  local_security_policy { 'Debug programs':
    ensure         => 'present',
    policy_setting => 'SeDebugPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73757
  # The Deny access to this computer from the network user right on domain controllers must be configured to prevent
  # unauthenticated access.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Deny access to this computer from the network':
      ensure         => 'present',
      policy_setting => 'SeDenyNetworkLogonRight',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-546',
    }
  }
  else {
    # V-73759
    # The Deny access to this computer from the network user right on member servers must be configured to prevent
    # access from highly privileged domain accounts and local accounts on domain systems, and from unauthenticated access on all systems.
    if($facts['windows_type'] =~ /(0|2)/) {
      #standalone
      local_security_policy { 'Deny access to this computer from the network':
        ensure         => 'present',
        policy_setting => 'SeDenyNetworkLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => '*S-1-5-32-546',
      }
    }
    elsif ($facts['windows_type'] =~ /(1|3)/) {
      #member server
      local_security_policy { 'Deny access to this computer from the network':
        ensure         => 'present',
        policy_setting => 'SeDenyNetworkLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => 'Domain Admins,Enterprise Admins,*S-1-5-32-546,*S-1-5-114',
      }
    }
  }

  # V-73761
  # The Deny log on as a batch job user right on domain controllers must be configured to prevent unauthenticated access.
  # V-73763
  # The Deny log on as a batch job user right on member servers must be configured to prevent access from highly privileged domain
  # accounts on domain systems and from unauthenticated access on all systems.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Deny log on as a batch job':
      ensure         => 'present',
      policy_setting => 'SeDenyBatchLogonRight',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-546',
    }
  }
  else {
    if($facts['windows_type'] =~ /(0|2)/) {
      #standalone
      local_security_policy { 'Deny log on as a batch job':
        ensure         => 'present',
        policy_setting => 'SeDenyBatchLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => '*S-1-5-32-546',
      }
    }
    elsif ($facts['windows_type'] =~ /(1|3)/) {
      #member server
      local_security_policy { 'Deny log on as a batch job':
        ensure         => 'present',
        policy_setting => 'SeDenyBatchLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => 'Domain Admins,Enterprise Admins,*S-1-5-32-546',
      }
    }
  }

  # V-73765
  # The Deny log on as a service user right must be configured to include no accounts or groups (blank) on domain controllers.
  # V-73767
  # The Deny log on as a service user right on member servers must be configured to prevent access from highly privileged domain
  # accounts on domain systems. No other groups or accounts must be assigned this right.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Deny log on as a service':
      ensure         => 'absent',
    }
  }
  else {
    if($facts['windows_type'] =~ /(0|2)/) {
      #standalone
      local_security_policy { 'Deny log on as a service':
        ensure         => 'absent',
      }
    }
    elsif ($facts['windows_type'] =~ /(1|3)/) {
      #member server
      local_security_policy { 'Deny log on as a service':
        ensure         => 'present',
        policy_setting => 'SeDenyServiceLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => 'Domain Admins,Enterprise Admins',
      }
    }
  }

  # V-73769
  # The Deny log on locally user right on domain controllers must be configured to prevent unauthenticated access.
  # V-73771
  # The Deny log on locally user right on member servers must be configured to prevent access from highly privileged domain accounts on
  # domain systems and from unauthenticated access on all systems.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Deny log on locally':
      ensure         => 'present',
      policy_setting => 'SeDenyInteractiveLogonRight',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-546',
    }
  }
  else {
    if($facts['windows_type'] =~ /(0|2)/) {
      #standalone
      local_security_policy { 'Deny log on locally':
        ensure         => 'present',
        policy_setting => 'SeDenyInteractiveLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => '*S-1-5-32-546',
      }
    }
    elsif ($facts['windows_type'] =~ /(1|3)/) {
      #member server
      #NOTE: Systems dedicated to the management of Active Directory are exempt from this :(
      local_security_policy { 'Deny log on locally':
        ensure         => 'present',
        policy_setting => 'SeDenyInteractiveLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => 'Domain Admins,Enterprise Admins,*S-1-5-32-546',
      }
    }
  }

  # V-73773
  # The Deny log on through Remote Desktop Services user right on domain controllers must be configured to prevent unauthenticated access.
  # V-73775
  # The Deny log on through Remote Desktop Services user right on member servers must be configured to prevent access from highly
  # privileged domain accounts and all local accounts on domain systems and from unauthenticated access on all systems.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Deny log on through Remote Desktop Services':
      ensure         => 'present',
      policy_setting => 'SeDenyRemoteInteractiveLogonRight',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-546',
    }
  }
  else {
    if($facts['windows_type'] =~ /(0|2)/) {
      #standalone
      local_security_policy { 'Deny log on through Remote Desktop Services':
        ensure         => 'present',
        policy_setting => 'SeDenyRemoteInteractiveLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => '*S-1-5-32-546',
      }
    }
    elsif ($facts['windows_type'] =~ /(1|3)/) {
      #member server
      #NOTE: Systems dedicated to the management of Active Directory are exempt from this :(
      local_security_policy { 'Deny log on through Remote Desktop Services':
        ensure         => 'present',
        policy_setting => 'SeDenyRemoteInteractiveLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => 'Domain Admins,Enterprise Admins,*S-1-5-32-546,*S-1-5-113',
      }
    }
  }

  # V-73777
  # The Enable computer and user accounts to be trusted for delegation user right must only be assigned to the Administrators group on
  # domain controllers.
  if($facts['windows_server_type'] == 'windowsdc') {
    local_security_policy { 'Enable computer and user accounts to be trusted for delegation':
      ensure         => 'present',
      policy_setting => 'SeEnableDelegationPrivilege',
      policy_type    => 'Privilege Rights',
      policy_value   => '*S-1-5-32-544',
    }
  }

  # V-73779
  # The Enable computer and user accounts to be trusted for delegation user right must not be assigned to any groups or accounts on member
  # servers.
  if($facts['windows_server_type'] == 'MemberServer') {
    local_security_policy { 'Enable computer and user accounts to be trusted for delegation':
      ensure         => 'absent',
    }
  }

  # V-73781
  # The Force shutdown from a remote system user right must only be assigned to the Administrators group.
  local_security_policy { 'Force shutdown from a remote system':
    ensure         => 'present',
    policy_setting => 'SeRemoteShutdownPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73783
  # The Generate security audits user right must only be assigned to Local Service and Network Service.
  local_security_policy { 'Generate security audits':
    ensure         => 'present',
    policy_setting => 'SeAuditPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-19,*S-1-5-20',
  }

  # V-73785
  # The Impersonate a client after authentication user right must only be assigned to Administrators, Service, Local Service, and Network
  # Service.
  local_security_policy { 'Impersonate a client after authentication':
    ensure         => 'present',
    policy_setting => 'SeImpersonatePrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-19,*S-1-5-20,*S-1-5-32-544,*S-1-5-6',
  }

  # V-73787
  # The Increase scheduling priority user right must only be assigned to the Administrators group.
  local_security_policy { 'Increase scheduling priority':
    ensure         => 'present',
    policy_setting => 'SeIncreaseBasePriorityPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73789
  # The Load and unload device drivers user right must only be assigned to the Administrators group.
  local_security_policy { 'Load and unload device drivers':
    ensure         => 'present',
    policy_setting => 'SeLoadDriverPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73791
  # The Lock pages in memory user right must not be assigned to any groups or accounts.
  local_security_policy { 'Lock pages in memory':
    ensure         => 'absent',
  }

  # V-73793
  # The Manage auditing and security log user right must only be assigned to the Administrators group.
  local_security_policy { 'Manage auditing and security log':
    ensure         => 'present',
    policy_setting => 'SeSecurityPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73795
  # The Modify firmware environment values user right must only be assigned to the Administrators group.
  local_security_policy { 'Modify firmware environment values':
    ensure         => 'present',
    policy_setting => 'SeSystemEnvironmentPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73797
  # The Perform volume maintenance tasks user right must only be assigned to the Administrators group.
  local_security_policy { 'Perform volume maintenance tasks':
    ensure         => 'present',
    policy_setting => 'SeManageVolumePrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73799
  # The Profile single process user right must only be assigned to the Administrators group.
  local_security_policy { 'Profile single process':
    ensure         => 'present',
    policy_setting => 'SeProfileSingleProcessPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73801
  # The Restore files and directories user right must only be assigned to the Administrators group.
  local_security_policy { 'Restore files and directories':
    ensure         => 'present',
    policy_setting => 'SeRestorePrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73803
  # The Take ownership of files or other objects user right must only be assigned to the Administrators group.
  local_security_policy { 'Take ownership of files or other objects':
    ensure         => 'present',
    policy_setting => 'SeTakeOwnershipPrivilege',
    policy_type    => 'Privilege Rights',
    policy_value   => '*S-1-5-32-544',
  }

  # V-73809
  # The built-in guest account must be disabled.
  local_security_policy { 'EnableGuestAccount':
    ensure         => 'present',
    policy_setting => 'EnableGuestAccount',
    policy_type    => 'System Access',
    policy_value   => '0',
  }
}
