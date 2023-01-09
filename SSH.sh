#!/usr/bin/ksh
################################################
#                                              #
#   Function: Security Healthcheck for SSH     #
#   By: Gerson Rodrigo Varela Reyna            #
#                                              #
################################################

#Variables
today=`date +%Y%m%d`
auxliar="KO"
#########################BASIC FUNCTION #####################################
function Validauser {
	#Help to validate the user
    var1=`whoami`
    if [[ $var1 != root ]];then
        var2=` sudo -l  2>/dev/null | grep -i  "(root) NOPASSWD" | grep -w cat 2>/dev/null`
        var3=` sudo -l  2>/dev/null | grep -i  "(root) NOPASSWD" | grep -w find 2>/dev/null`
        var4=` sudo -l  2>/dev/null | grep -i  "(root) NOPASSWD" | grep -w ls 2>/dev/null`
                #Validar la existencia de la cuenta lsftnd
        if [[ ! -z $var2 ]] && [[ ! -z $var3 ]] && [[ ! -z $var4 ]] ;then
            cat1="sudo cat"
            ls1="sudo ls"
            find1="sudo find"
            echo "It will execute with the user: $var1"
        else
            echo "ERROR sudoers incorrect"
            exit 0
        fi
    else
        echo "It will execute with the user : $var1"
        cat1="cat"
        ls1="ls"
        find1="find"
       
    fi
    echo "Starting execution" 
    echo "Option: HealthCheck" 
    echo `Sistemaop` 
    date 
    }
function Sistemaop {
	#Calculating O.S
    OS=`uname`
    case $OS in
        Linux*)
        ##REDHAT
                if [ -f /etc/redhat-release ]; then
                    DIST='RedHat'
                    REV1=$(cat /etc/redhat-release |sed s/.*release\ // |sed s/\ .*//)
                    REV=`echo Version: $REV1`

        ##SUSE
                elif [ -f /etc/SuSE-release ]; then
                    DIST='Suse'
                    REV1=$(cat /etc/SuSE-release |tr "\n" ' '|sed s/VERSION.*//)
                    REV=`echo Version: $REV1`
        ##DEBIAN
                elif [ -f /etc/debian_version ]; then
                    DIST="$(cat /etc/*release |egrep -vi 'pretty|code' |grep -i name |cut -c6-50 |sed s/\"//|awk '{print $1}')"
                    REV=$(cat /etc/*release |grep -iw "Version" |sed s/\ =/:/)               
               fi
                    OSSTR="Distribucion: ${DIST} ${REV}"
                    echo ${OSSTR}
                ;;
        SunOS*)
        ##Solaris
                OS1=`echo "Solaris"`
                DIST='Solaris'
                REV=$(uname -r)
                OSSTR="Distribucion: ${DIST} Version: ${REV}"
                echo ${OSSTR}
                ;;
        AIX*)
        ##AIX
                OS1=`echo "AIX"`
                DIST='AIX'
                REV=$(oslevel)
                OSSTR="Distribucion: ${DIST} Version: ${REV}"
                echo ${OSSTR}
                ;;
        HP-UX*)
        #HP-UX
                OS1=`echo "HP-UX"`
                DIST='HP-UX'
                REV=$(uname -r)
                OSSTR="Distribucion: ${DIST} Version: ${REV}"
                echo ${OSSTR}
                ;;
        *)
                echo "Sistema Operativo no soportado, favor de configurar el modelo de seguridad para $account manualmente"
                ;;
    esac
    }
function exists {
    #If a file exists
    var=` ${ls1} -l $1 2>/dev/null`
    if [[ ! -z $var ]]; then
        echo $1
    else
        echo "No se encuentra ruta"
    fi
    }
# ######################### HealthCheck #################################################
# ██╗  ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗ ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
# ██║  ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
# ███████║█████╗  ███████║██║     ██║   ███████║██║     ███████║█████╗  ██║     █████╔╝ 
# ██╔══██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ 
# ██║  ██║███████╗██║  ██║███████╗██║   ██║  ██║╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
# ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
# ######################### HealthCheck #################################################
function leer {
	#Read a file and evaluate parameter and value
    var=`exists "$1" 2>/dev/null`
    if [[ $var != "No se encuentra ruta" ]]; then
        file=` ${cat1} $1 2>/dev/null | egrep -v "#" | egrep -i "$2" 2>/dev/null`
        file2=`echo $file | egrep -i $3 2>/dev/null`
        if [[ ! -z $file2 ]];then
            echo "Politic $4 - In compliance" 
        else
            echo "Politic $4 - No compliance " 
            echo "Ruta:$1 Parametro:$2" 
        fi
    else
        echo "Politic $4 - NOT compliance" 
        echo "File not found $1" 
    fi
    }
function mustnotexist {
	#Validate if a file exist, if exists is no compliance
    var=`exists "$1" 2>/dev/null`
    if [[ $var != "No se encuentra ruta" ]]; then
            echo "Politic $2 - No compliance" 
            echo "Ruta:$1" 
    else
            echo "Politic $2 - In compliance "            
    fi
    }
function entries3 {
	#Enter to a file, found paths and evulate permissions of the paths found- 
    tmp1=`echo $3 | sed 's/\./_/g'`
    touch /tmp/list-patvar2-$tmp1.txt
    touch /tmp/path-2-$tmp1.txt
    touch /tmp/path-3-$tmp1.txt
    aux=` ${cat1} $1  2>/dev/null | egrep $2 | egrep -o "(/[[:alnum:]]*[[:punct:]]*[[:alnum:]]*){1,}" | egrep "$5" | tr -s [:space:]  2>/dev/null >> /tmp/list-patvar2-$tmp1.txt ` 
   # cat /tmp/list-patvar2-$tmp1.txt
    while read linea
        do
            var2=`echo $linea | awk -F"/" '{print NF-1}' `
            var3=`echo $linea | cut -d"/" -f 1-$var2 2>/dev/null` #| egrep -v "/usr/usr/bin /bin|^/usr/sbin|^/sbin|^/usr/bin|/bin|^/proc|^/dev|^/var/log" 2>/dev/null`
            if [[ ! -z $var3 ]];then
                var4=` ${find1} "$linea" -maxdepth 1 -name "*" \( ${4} \) -ls 2>/dev/null >> /tmp/path-2-$tmp1.txt` 
               # echo "sudo find $linea -maxdepth 1  \( ${4} \) -ls "
            fi
        done < /tmp/list-patvar2-$tmp1.txt 
     ${cat1} /tmp/path-2-$tmp1.txt  2>/dev/null | sort | uniq > /tmp/path-3-$tmp1.txt
    var5=`${cat1} /tmp/path-3-$tmp1.txt | wc -l 2>/dev/null `
    if [[ $var5 == 0 ]];then 
        echo "Politic $3 - In compliance" 
    else
        echo "Politic $3 - No compliance" 
        ${cat1} /tmp/path-3-$tmp1.txt 2>/dev/null 
    fi  
    rm /tmp/list-patvar2-$tmp1.txt
    rm /tmp/path-2-$tmp1.txt
    rm /tmp/path-3-$tmp1.txt
    }
function permisos {
	#Evualte permisos of files or directors
    var=` ${find1} $1 $5 -name "$2" \( ${3} \) -ls 2>/dev/null`   
    if [[ -z $var ]];then
            echo "Politica $4 - In compliance" 
    else
            echo "Politica $4 - No compliance " 
            echo "$var" 
    fi
    }
######################### Main #######################################################
# ███╗   ███╗ █████╗ ██╗███╗   ██╗
# ████╗ ████║██╔══██╗██║████╗  ██║
# ██╔████╔██║███████║██║██╔██╗ ██║
# ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
# ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
# ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ 
######################### Main #######################################################
    Validauser 
#Functions
	leer "/etc/ssh/sshd_config" "PermitEmptyPasswords" "no" "SSH.1.1.1" "Password Requirements"
	permisos "/home /export/home" "id_*" "-perm -g+r -o -perm -g+w -o -perm -g+x -o -perm -o+r -o -perm -o+w -o -perm -o+x"  "SSH.1.1.6"  "-type f -prune 3"
	leer "/etc/ssh/sshd_config" "LogLevel" "INFO" "SSH.1.2.1.2" "Password Requirements"
	entries3 "/etc/syslog.conf /etc/syslog-ng/syslog-ng.conf /etc/rsyslog.conf" "authpriv" "SSH.1.2.1.3"  "-perm -o+w -o -uid +0 -o -gid +0" "[[:alnum:]]"
	leer "/etc/ssh/sshd_config" "Quietmode" "no" "SSH.1.2.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "ClientAliveInterval" "300" "SSH.1.4.1" "Password Requirements"
	leer "/etc/ssh/sshd_config" "ClientAliveCountMax" "0" "SSH.1.4.1" "Password Requirements"
	leer "/etc/ssh/sshd_config" "TCPKeepAlive" "yes" "SSH.1.4.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "LoginGraceTime" "120" "SSH.1.4.3" "Password Requirements"
	leer "/etc/ssh/sshd_config" "MaxConnections" "100" "SSH.1.4.4" "Password Requirements"
	leer "/etc/ssh/sshd_config" "MaxStartups" "100" "SSH.1.4.5" "Password Requirements"
	leer "/etc/ssh/sshd_config" "MaxAuthTries" "3" "SSH.1.4.8" "Password Requirements"
	leer "/etc/ssh/sshd_config" "AuthKbdInt.Retries" "3" "SSH.1.4.14" "Password Requirements"
	leer "/etc/ssh/sshd_config" "KeyRegenerationInterval" "300" "SSH.1.5.1" "Password Requirements"
	leer "/etc/ssh/sshd_config" "Protocol" "2" "SSH.1.5.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "GatewayPorts" "no" "SSH.1.5.5" "Password Requirements"
	leer "/etc/ssh/sshd_config" "PermitRootLogin" "no" "SSH.1.7.1.1" "Password Requirements"
	leer "/etc/ssh/sshd_config" "PermitRootLogin" "no" "SSH.1.7.1.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "Ciphers" "aes128-ctr,aes192-ctr,aes256-ctr"  "SSH.1.7.1.2" "Password Requirements"
	mustnotexist "/etc/hosts.equiv" "SSH.1.7.3.2" "Network-settings"
	permisos "/usr/bin /bin" "openssl" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.1"  "-type f -prune"
	permisos "/usr/bin /bin" "scp" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.2"  "-type f -prune"
	permisos "/usr/bin /bin" "scp2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.3"  "-type f -prune"
	permisos "/usr/bin /bin" "sftp" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.4"  "-type f -prune"
	permisos "/usr/bin /bin" "sftp2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.5 " "-type f -prune"
	permisos "/usr/bin /bin" "sftp-server" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.6"  "-type f -prune"
	permisos "/usr/bin /bin" "sftp-server2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.7"  "-type f -prune"
	permisos "/usr/bin /bin" "slogin" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.8"  "-type f -prune"
	permisos "/usr/bin /bin" "ssh" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.9 " "-type f -prune"
	permisos "/usr/bin /bin" "ssh2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.10" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-add" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.11" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-add2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.12" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-agent" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.13" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-agent2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.14" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-askpass" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.15" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-askpass2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.16" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-certenroll2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.17" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-chrootmgr" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.18" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-dummy-shell" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.19" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-keygen" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.20" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-keygen2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.21" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-keyscan" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.22" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-pam-client" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.23" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-probe" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.24" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-probe2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.25" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-pubkeymgr" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.26" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-signer" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.27" "-type f -prune"
	permisos "/usr/bin /bin" "ssh-signer2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.28" "-type f -prune"
	permisos "/lib" "libcrypto.a" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.29" "-type f -prune"
	permisos "/lib" "libssh.a" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.30" "-type f -prune"
	permisos "/lib" "libssl.a" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.31" "-type f -prune"
	permisos "/lib" "libz.a" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.32" "-type f -prune"
	permisos "/lib-exec/openssh" "sftp-server" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.33" "-type f -prune"
	permisos "/lib-exec/openssh" "ssh-keysign" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.34" "-type f -prune"
	permisos "/lib-exec/openssh" "ssh-askpass" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.35" "-type f -prune"
	permisos "/lib-exec" "sftp-server" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.36" "-type f -prune"
	permisos "/lib-exec" "ssh-keysign" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.37" "-type f -prune"
	permisos "/lib-exec" "ssh-rand-helper" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.38" "-type f -prune"
	permisos "/libexec/openssh" "sftp-server" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.39" "-type f -prune"
	permisos "/libexec/openssh/" "/ssh-keysign" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.40" "-type f -prune"
	permisos "/libexec/openssh" "/ssh-askpass" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.41" "-type f -prune"
	permisos "/libexec" "sftp-server" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.42" "-type f -prune"
	permisos "/libexec" "ssh-keysign" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.43" "-type f -prune"
	permisos "/libexec/" "ssh-rand-helper" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.44" "-type f -prune"
	permisos "/sbin" "sshd" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.45" "-type f -prune"
	permisos "/sbin/sshd2"  "sshd" "uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.46" "-type f -prune"
	permisos "/sbin/" "sshd-check-conf" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.47" "-type f -prune"
	permisos "/lib/svc/method" "/sshd" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.49" "-type f -prune"
	permisos "/usr/lib/ssh/" "sshd2" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.2.50" "-type f -prune"
	permisos "/etc/openssh/" "sshd_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.1"  "-type f -prune"
	permisos "/etc/ssh" "sshd_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.2"  "-type f -prune"
	permisos "/etc/ssh" "sshd2_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.3"  "-type f -prune"
	permisos "/etc/ssh2" "sshd_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.4 " "-type f -prune"
	permisos "/etc/ssh2" "sshd2_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.5"  "-type f -prune"
	permisos "/etc" "sshd_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.6" "-type f -prune"
	permisos "/etc" "sshd2_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.7" "-type f -prune"
	permisos "/usr/local/etc" "sshd_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.8 " "-type f -prune"
	permisos "/usr/local/etc" "sshd2_config" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.9"  "-type f -prune"
	permisos "/usr/lib/ssh" "ssh-keysign" "-uid +499 -o -gid +499 -o -perm -o+w" "SSH.1.8.3.10"
	leer "/etc/ssh/sshd_config" "PermitUserEnvironment" "no"  "SSH.1.9.1" "Password Requirements"
	leer "/etc/ssh/sshd_config" "StrictModes" "no"  "SSH.1.9.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "PrintMotd" "yes"  "SSH.2.0.1.1" "Password Requirements"
	leer "/etc/motd /etc/issue" "Confid" "Confid" "SSH.2.0.1.1" "Business Use Notice"
	leer "/etc/ssh/sshd_config" "Protocol" "2" "SSH.1.5.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "Ciphers" "aes128-ctr,aes192-ctr,aes256-ctr" "SSH.1.7.2" "Password Requirements"
	leer "/etc/ssh/sshd_config" "Ciphers" "aes128-ctr,aes192-ctr,aes256-ctr" "SSH.1.7.2" "Password Requirements"
