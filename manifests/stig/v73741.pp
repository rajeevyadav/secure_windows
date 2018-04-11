# This class manages:
# V-73741
# The Allow log on through Remote Desktop Services user right must only be assigned to the Administrators group.
class secure_windows::stig::v73741 (
  Boolean $enforced = false,
) {
  if $enforced {
    if($facts['windows_server_type'] == 'windowsdc') {
      local_security_policy { 'Allow log on through Remote Desktop Services':
        ensure         => 'present',
        policy_setting => 'SeRemoteInteractiveLogonRight',
        policy_type    => 'Privilege Rights',
        policy_value   => '*S-1-5-32-544',
      }
    }
  }
}
