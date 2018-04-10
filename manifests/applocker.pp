# Profile class for AppLocker configuration.
#

class secure_windows::applocker {

  # Must enable access to powershell.exe since it is used by the applocker_rule provider to enforce rules.
  #

  applocker_rule { '(Puppet Rule) Allow Puppet to run powershell.exe (the applocker_rule provider).':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '%SYSTEM32%\WindowsPowerShell\v1.0\powershell.exe'
    }],
    description       => 'Allow Administrator to execute %SYSTEM32%\WindowsPowerShell\v1.0\powershell.exe',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Exe',
    user_or_group_sid => 'S-1-5-32-544',
  }

  # V-73225
  # Administrative accounts must not be used with applications that access the Internet, such as web browsers, or with potential Internet sources, such as email.
  #

  applocker_rule { '(STIG Rule) V-73225 - Disable IE for Administrators':
    ensure            => 'present',
    action            => 'Deny',
    conditions        => [
    {
      'publisher'  => 'O=MICROSOFT CORPORATION, L=REDMOND, S=WASHINGTON, C=US',
      'product'    => 'INTERNET EXPLORER',
      'binaryname' => '*',
      'hi_version' => '*',
      'lo_version' => '11.0.0.0'
    }],
    description       => 'STIG Rule addressing vulnerability V-73225: Administrative accounts must not be used with applications that access the Internet, such as web browsers, or with potential Internet sources, such as email.',
    mode              => 'NotConfigured',
    rule_type         => 'publisher',
    type              => 'Exe',
    user_or_group_sid => 'S-1-5-32-544',
  }


  # V-73235
  # Windows Server 2016 must employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs.
  #
  # Disabled denial of .exe's or instance is useless.
  # Discuss what to enable after applying a deny-all policy.
  #
  # applocker_rule { '(STIG Rule) V-73235 - Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all executable files).':
  #   ensure            => 'present',
  #   action            => 'Deny',
  #   conditions        => [
  #   {
  #     'path' => '*'
  #   }],
  #   description       => 'STIG Rule addressing vulnerability V-73235: Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all executable files).',
  #   mode              => 'NotConfigured',
  #   rule_type         => 'path',
  #   type              => 'Exe',
  #   user_or_group_sid => 'S-1-1-0',
  # }

  # V-73235
  applocker_rule { '(STIG Rule) V-73235 - Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all Windows Installer files).':
    ensure            => 'present',
    action            => 'Deny',
    conditions        => [
    {
      'path' => '*.*'
    }],
    description       => 'STIG Rule addressing vulnerability V-73235: Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all Windows Installer files).',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Msi',
    user_or_group_sid => 'S-1-1-0',
  }

  # V-73235
  applocker_rule { '(STIG Rule) V-73235 - Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all scripts).':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '*'
    }],
    description       => 'STIG Rule addressing vulnerability V-73235 - Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all scripts).',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Script',
    user_or_group_sid => 'S-1-1-0',
  }

  # V-73235
  applocker_rule { '(STIG Rule) V-73235 - Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all signed packaged apps).':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'publisher'  => '*',
      'product'    => '*',
      'binaryname' => '*',
      'hi_version' => '*',
      'lo_version' => '0.0.0.0'
    }],
    description       => 'STIG Rule addressing vulnerability V-73235 - Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs (all signed packaged apps).',
    mode              => 'NotConfigured',
    rule_type         => 'publisher',
    type              => 'Appx',
    user_or_group_sid => 'S-1-1-0',
  }

  # Deny access to USB, DVD, etc.
  #

  applocker_rule {'(Puppet Rule) Lock down removable storage device (for example, USB flash drive)':
    ensure            => present,
    action            => 'Deny',
    conditions        => [ { 'path' => '%HOT%\*' } ],
    description       => 'Lock down removable storage device (for example, USB flash drive)',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Exe',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule {'(Puppet Rule) Lock down Removable media (for example, CD or DVD)':
    ensure            => present,
    action            => 'Deny',
    conditions        => [ { 'path' => '%REMOVABLE%\*' } ],
    description       => 'Lock down removable media (for example, CD or DVD)',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Exe',
    user_or_group_sid => 'S-1-1-0',
  }



  # Create AppLocker "Default Rules" before starting the AppIDSvc service.
  #

  applocker_rule { '(Default Rule) All Windows Installer files':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '*.*'
    }],
    description       => 'Allows members of the local Administrators group to run all Windows Installer files.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Msi',
    user_or_group_sid => 'S-1-5-32-544',
  }

  applocker_rule { '(Default Rule) All Windows Installer files in %systemdrive%\Windows\Installer':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '%WINDIR%\Installer\*'
    }],
    description       => 'Allows members of the Everyone group to run all Windows Installer files located in %systemdrive%\Windows\Installer.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Msi',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule { '(Default Rule) All digitally signed Windows Installer files':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'publisher'  => '*',
      'product'    => '*',
      'binaryname' => '*',
      'hi_version' => '*',
      'lo_version' => '0.0.0.0'
    }],
    description       => 'Allows members of the Everyone group to run digitally signed Windows Installer files.',
    mode              => 'NotConfigured',
    rule_type         => 'publisher',
    type              => 'Msi',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule { '(Default Rule) All files':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '*'
    }],
    description       => 'Allows members of the local Administrators group to run all applications.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Exe',
    user_or_group_sid => 'S-1-5-32-544',
  }

  applocker_rule { '(Default Rule) All files located in the Program Files folder':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '%PROGRAMFILES%\*'
    }],
    description       => 'Allows members of the Everyone group to run applications that are located in the Program Files folder.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Exe',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule { '(Default Rule) All files located in the Windows folder':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '%WINDIR%\*'
    }],
    description       => 'Allows members of the Everyone group to run applications that are located in the Windows folder.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Exe',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule { '(Default Rule) All scripts':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '*'
    }],
    description       => 'Allows members of the local Administrators group to run all scripts.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Script',
    user_or_group_sid => 'S-1-5-32-544',
  }

  applocker_rule { '(Default Rule) All scripts located in the Program Files folder':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '%PROGRAMFILES%\*'
    }],
    description       => 'Allows members of the Everyone group to run scripts that are located in the Program Files folder.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Script',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule { '(Default Rule) All scripts located in the Windows folder':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'path' => '%WINDIR%\*'
    }],
    description       => 'Allows members of the Everyone group to run scripts that are located in the Windows folder.',
    mode              => 'NotConfigured',
    rule_type         => 'path',
    type              => 'Script',
    user_or_group_sid => 'S-1-1-0',
  }

  applocker_rule { '(Default Rule) All signed packaged apps':
    ensure            => 'present',
    action            => 'Allow',
    conditions        => [
    {
      'publisher'  => '*',
      'product'    => '*',
      'binaryname' => '*',
      'hi_version' => '*',
      'lo_version' => '0.0.0.0'
    }],
    description       => 'Allows members of the Everyone group to run packaged apps that are signed.',
    mode              => 'NotConfigured',
    rule_type         => 'publisher',
    type              => 'Appx',
    user_or_group_sid => 'S-1-1-0',
  }

  # AppLockerPolicy requires this service is running to enforce AppLocker policies.
  #

  service { 'application identity service':
    ensure => running,
    name   => 'AppIDSvc',
    enable => true,
  }

}
