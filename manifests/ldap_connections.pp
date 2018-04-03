# This class manages V-73387
class secure_windows::ldap_connections {
  if($facts['windows_server_type'] == 'windowsdc') {
    # V-73387
    # The directory service must be configured to terminate LDAP-based network connections to the directory server after 5 minutes of inactivity.
    $num = 0 + $facts['maxconnidletime']
    if $num > 300 {
      exec { 'V-73387: Set NTDSUtil MaxConnIdleTime':
        command => "C:\\Windows\\System32\\ntdsutil.exe \"LDAP policies\" \"connections\" \"connect to server ${facts['fqdn']}\" \"q\" \"Set MaxConnIdleTime to 300\" \"Commit Changes\" \"q\" \"q\""
      }
    }
  }
}