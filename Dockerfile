# Version: 0.0.1
# @edt M06 2018-2019
# hostpam
# -------------------------------------
FROM fedora:28
LABEL author="@joterop"
LABEL description="sshd"
RUN dnf -y install procps passwd openldap-clients passwd nss-pam-ldapd authconfig openssh-server pam_mount tree
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/install.sh /opt/docker/startup.sh
WORKDIR /opt/docker
CMD ["/opt/docker/startup.sh"]
