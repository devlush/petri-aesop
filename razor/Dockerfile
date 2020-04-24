
FROM centos:7.7.1908

RUN set -x \
        && cd $(mktemp -d) \
        && curl -sO http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm \
        && sha256sum puppetlabs-release-pc1-el-7.noarch.rpm | cut -d' ' -f1 \
          | xargs -I % test '%' == '2e06d973a73fc3003f6305896fe9575f8bc8d471c0a110a86a7d977e2888cf52' \
        && yum -y -q install ./*.rpm \
        \
        && sha256sum /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs-PC1 | cut -d' ' -f1 \
          | xargs -I % test '%' == 'a2a6ac449c6c0cb2e821d7f5bd12002820de4a5da73202233159ef9f5354436e' \
        && sha256sum /etc/pki/rpm-gpg/RPM-GPG-KEY-puppet-PC1 | cut -d' ' -f1 \
          | xargs -I % test '%' == '229d53569fb16ea1de72e6e478cc5e64acc19bd592df4dbe321ce98561704723' \
        \
        && yum -y -q install centos-release-scl-rh centos-release-scl \
        \
        && sha256sum /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 | cut -d' ' -f1 \
          | xargs -I % test '%' == '8b48b04b336bd725b9e611c441c65456a4168083c4febc28e88828d8ec14827f' \
        && sha256sum /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo | cut -d' ' -f1 \
          | xargs -I % test '%' == 'db1ce0b0a5eea629a3e272934e382764c63c54e8d0f2f267d88cba86eb803b27' \
        \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs-PC1 \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puppet-PC1 \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo \
        \
        && yum -y -q install sudo \
        \
        && sed -i 's/^\s*\(%wheel\s*ALL=(ALL)\sALL\)/# \1/' /etc/sudoers \
        && sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*NOPASSWD:\s*ALL\)/\1/' /etc/sudoers \
        \
        && useradd razor \
        && usermod -aG wheel razor \
        \
        && yum -y -q install \
            centos-release-scl-rh \
            centos-release-scl \
            rh-ruby26 \
        \
        && yum -y -q install \
            razor-server-1.7.1-1.el7 \
            puppetserver-2.8.1-1.el7 \
            nmap-ncat \
        \
        && yum -y -q install \
            postgresql \
            net-tools \
            iproute \
            wget \
            tree \
            vim


ARG DB_URL
ADD pollsocket.sh /usr/local/bin/
ADD entrypoint.sh /usr/local/bin/
RUN /usr/local/bin/entrypoint.sh

USER razor

CMD pollsocket.sh ${POLL_SOCKET} \
    && /opt/puppetlabs/bin/razor-admin -e production migrate-database \
    && /opt/puppetlabs/server/apps/razor-server/share/torquebox/jboss/bin/standalone.sh \
        -Djboss.server.log.dir=${JBOSS_LOG_DIR} \
        -Dhttp.port=${RAZOR_HTTP_PORT} \
        -Dhttps.port=${RAZOR_HTTPS_PORT} \
        -b 0.0.0.0

