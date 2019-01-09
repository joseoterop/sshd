#! /bin/bash
# @edt ASIX M06 2018-2019
# instalacion
#  - crear usuaris locals
# -------------------------------------

#useradd
useradd exam01
useradd exam02
useradd exam03


#locales
echo "exam01" | passwd --stdin exam01
echo "exam02" | passwd --stdin exam02
echo "exam03" | passwd --stdin exam03

#configuracion del servidor parte PAM

bash /opt/docker/auth.sh
cp /opt/docker/nslcd.conf /etc/nslcd.conf
cp /opt/docker/ldap.conf /etc/openldap/ldap.conf
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/sshd /etc/pam.d/sshd

#modificar los parametros del servidor sshd

ssh-keygen -A
sed -i s'/#Port 22/Port 1022/g' "/etc/ssh/sshd_config"

# restriccion de usuarios
echo "AllowUsers pere exam01 anna exam02" >> /etc/ssh/sshd_config

# restriccion de usuarios
echo "-:anna:ALL" >> /etc/security/access.conf



