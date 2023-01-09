# SSH- Hardening

This helps to identify some hardening common SSH Desviation into linux systems.
It need to be executed as root or a user with sudoers priviledge:

Example of sudoers:

  $USER ALL=(root) NOPASSWD: /usr/bin/cat
  
  $USER  ALL=(root) NOPASSWD: /usr/bin/find
  
  $USER  ALL=(root) NOPASSWD: /usr/bin/ls

Some of the parameters: 

  PermitEmptyPasswords
  Private Key Passphrases - system-to-system authentication
  LogLevel
  QuietMode
  KeepAlive
  TCPKeepAlive
  LoginGraceTime
  MaxConnections
  MaxStartups
  MaxAuthTries
  AuthKbdInt.Retries
  KeyRegenerationInterval
  Protocol
  GatewayPorts
  PermitRootLogin 
  Public Key Authentication
  Host-Based Authentication  /etc/hosts.equiv file
  bin/openssl
  bin/scp
  bin/scp2
  bin/sftp
  bin/sftp2
  bin/sftp-server
  bin/sftp-server2
  bin/slogin
  bin/ssh
  bin/ssh2
  bin/ssh-add
  bin/ssh-add2
  bin/ssh-agent
  bin/ssh-agent2
  bin/ssh-askpass
  bin/ssh-askpass2
  bin/ssh-certenroll2
  bin/ssh-chrootmgr
  bin/ssh-dummy-shell
  bin/ssh-keygen
  bin/ssh-keygen2
  bin/ssh-keyscan
  bin/ssh-pam-client
  bin/ssh-probe
  bin/ssh-probe2
  bin/ssh-pubkeymgr
  bin/ssh-signer
  bin/ssh-signer2
  lib/libcrypto.a
  lib/libssh.a
  lib/libssl.a
  lib/libz.a
  lib-exec/openssh/sftp-server
  lib-exec/openssh/ssh-keysign
  lib-exec/openssh/ssh-askpass
  lib-exec/sftp-server
  lib-exec/ssh-keysign
  lib-exec/ssh-rand-helper
  libexec/openssh/sftp-server
  libexec/openssh/ssh-keysign
  libexec/openssh/ssh-askpass
  libexec/sftp-server
  libexec/ssh-keysign
  libexec/ssh-rand-helper
  sbin/sshd
  sbin/sshd2
  sbin/sshd-check-conf
  /lib/svc/method/sshd
  /usr/lib/ssh/sshd
  /etc/openssh/sshd_config
  /etc/ssh/sshd_config
  /etc/ssh/sshd2_config
  /etc/ssh2/sshd_config
  /etc/ssh2/sshd2_config
  /etc/sshd_config
  /etc/sshd2_config
  /usr/local/etc/sshd_config
  /usr/local/etc/sshd2_config
  /usr/lib/ssh/ssh-keysign
  PermitUserEnvironment
  StrictModes
  AcceptEnv
  Business Use Notice 
  Data Transmission


Complete list, see the csv
