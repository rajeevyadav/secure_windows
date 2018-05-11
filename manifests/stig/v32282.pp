# This class manages V-32282
# Standard user accounts must only have Read permissions to the Active Setup\Installed Components registry key.
class secure_windows::stig::v32282 (
  Boolean $enforced = true,
) {
  if $enforced {
    reg_acl { ['hklm:software\\microsoft\\active setup\\installed components','hklm:software\\Wow6432Node\\microsoft\\active setup\\installed components']:
      inherit_from_parent => false,
      owner               => 'S-1-5-18',
      permissions         => [
      {
        'RegistryRights'    => 'ReadKey',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-5-32-545',
        'InheritanceFlags'  => 'None',
        'PropagationFlags'  => 'None'
      },
      {
        'RegistryRights'    => 'GENERIC_READ',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-5-32-545',
        'InheritanceFlags'  => 'ContainerInherit',
        'PropagationFlags'  => 'InheritOnly'
      },
      {
        'RegistryRights'    => 'FullControl',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-5-32-544',
        'InheritanceFlags'  => 'None',
        'PropagationFlags'  => 'None'
      },
      {
        'RegistryRights'    => 'GENERIC_ALL',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-5-32-544',
        'InheritanceFlags'  => 'ContainerInherit',
        'PropagationFlags'  => 'InheritOnly'
      },
      {
        'RegistryRights'    => 'FullControl',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-5-18',
        'InheritanceFlags'  => 'None',
        'PropagationFlags'  => 'None'
      },
      {
        'RegistryRights'    => 'GENERIC_ALL',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-5-18',
        'InheritanceFlags'  => 'ContainerInherit',
        'PropagationFlags'  => 'InheritOnly'
      },
      {
        'RegistryRights'    => 'GENERIC_ALL',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-3-0',
        'InheritanceFlags'  => 'ContainerInherit',
        'PropagationFlags'  => 'InheritOnly'
      },
      {
        'RegistryRights'    => 'ReadKey',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-15-2-1',
        'InheritanceFlags'  => 'None',
        'PropagationFlags'  => 'None'
      },
      {
        'RegistryRights'    => 'GENERIC_READ',
        'AccessControlType' => 'Allow',
        'IdentityReference' => 'S-1-15-2-1',
        'InheritanceFlags'  => 'ContainerInherit',
        'PropagationFlags'  => 'InheritOnly'
      }],
    }
  }
}