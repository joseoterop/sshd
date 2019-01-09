### Servidor SSH +PAM

#### Utilización:


**LDAP** docker run --rm --name ldap -h ldap --net ldapnet -d edtasixm06/ldapserver:18group

**sshd** docker run --rm --name ldap -h ldap --net ldapnet -d edtasixm06/ldapserver:18group

En primer lugar instalamos mediante la configuración habitual los paquetes necesarios para garantizar
una conexion con el servidor **LDAP** asi'como el servidor ssh.

* openldap-clients
* nss-pam-ldap
* openssh-server


1. Para garantizar el funcionamiento del demonio *sshd* debemos ejecutar:

 * ssh-keygen -A

De esta manera se ejecutan las claves necesarias para que el servidor sshd pueda arrancar, y usando un simple `sed` podemos cambiar el puerto por el que escucha el demonio.

  * sed -i s'/#Port 22/Port 1022/g' "/etc/ssh/sshd_config"

### Validación mediante protocolo LDAP

2. Para que se pueda conectar al servidor ssh usando usuarios de la base de datos ldap, tenemos que modificar el archivo `/etc/pam.d/sshd` e incluir...

```
auth            sufficient      pam_ldap.so
account         sufficient      pam_ldap.so
session         optional        pam_mount.so
session         sufficient      pam_ldap.so
session         optional        pam_mkhomedir.so

```

De manera que no simplemente valide contra los usuarios locales del sistema, sino que contemple los usuarios de la base de datos ldap la cual esta conectada con el servidor ssh mediante los demonios `nscd y nslcd`.


3. Implementar restricciones de usuarios


* AllowUsers

    hacemos un `echo "AllowUsers pere exam01 anna exam02" >> /etc/ssh/sshd_config` para añadir esta opcion al archivo de configuración del demonio

* pam_access.so

`echo "-:anna:ALL" >> /etc/security/access.conf`

* pam_listfile.so

debemos crear una lista de usuarios y añadir la siguiente linea al fichero pam sshd

```
auth    required        pam_listfile.so onerr=fail item=user sense=deny file=/opt/docker/lista.txt

```

#### Comprobación del funcionamiento

USUARIO LOCAL

```

[root@192 ~]# ssh exam01@172.18.0.3 -p 1022
The authenticity of host '[172.18.0.3]:1022 ([172.18.0.3]:1022)' can't be established.
ECDSA key fingerprint is SHA256:skh7CRPAFLnLvDLaRjrKQNcCQ+EJs5jEo+3wlZI92Hc.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[172.18.0.3]:1022' (ECDSA) to the list of known hosts.
exam01@172.18.0.3's password: 
[exam01@sshd ~]$ 
[exam01@sshd ~]$ exit

```

USUARIO LDAP

```
[root@192 ~]# ssh pere@172.18.0.3 -p 1022
pere@172.18.0.3's password: 
Creating directory '/tmp/home/pere'.
[pere@sshd ~]$ 


```





