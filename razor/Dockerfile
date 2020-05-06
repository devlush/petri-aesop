
FROM centos:7.7.1908

RUN set -x \
        && cd $(mktemp -d) \
        && curl -sO http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm \
        && printf '%s  %s' 2e06d973a73fc3003f6305896fe9575f8bc8d471c0a110a86a7d977e2888cf52 \
                             ./puppetlabs-release-pc1-el-7.noarch.rpm | sha256sum -c \
        && yum -y -q install ./puppetlabs-release-pc1-el-7.noarch.rpm \
        \
        && printf '%s  %s' a2a6ac449c6c0cb2e821d7f5bd12002820de4a5da73202233159ef9f5354436e \
                        /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs-PC1 | sha256sum -c \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs-PC1 \
        \
        && printf '%s  %s' 229d53569fb16ea1de72e6e478cc5e64acc19bd592df4dbe321ce98561704723 \
                        /etc/pki/rpm-gpg/RPM-GPG-KEY-puppet-PC1 | sha256sum -c \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-puppet-PC1 \
        \
        && yum -y -q install centos-release-scl-rh centos-release-scl \
        \
        && printf '%s  %s' db1ce0b0a5eea629a3e272934e382764c63c54e8d0f2f267d88cba86eb803b27 \
                        /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo | sha256sum -c \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo \
        \
        && printf '%s  %s' 8b48b04b336bd725b9e611c441c65456a4168083c4febc28e88828d8ec14827f \
                        /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 | sha256sum -c \
        && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
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

#ADD deps/microkernel-009.tar /opt/puppetlabs/server/data/razor-server/repo/
ADD https://s3-us-west-2.amazonaws.com/razor-releases/microkernel-009.tar /opt/puppetlabs/server/data/razor-server/repo/
RUN set -x \
    && cd /opt/puppetlabs/server/data/razor-server/repo/microkernel \
    && printf '%s  %s' 8664a4560115f9687ae071f6758734f90d7b9a5bd770783621b9ffdb8e84ce40 \
        initrd0.img | sha256sum -c \
    && printf '%s  %s' 1821d150ca2244fe1a0e8b0d69e8126670b08d7cc1c52139bcf47fc41a2effd0 \
        vmlinuz0 | sha256sum -c

CMD pollsocket.sh ${POLL_SOCKET} \
    && /opt/puppetlabs/bin/razor-admin -e production migrate-database \
    && /opt/puppetlabs/server/apps/razor-server/share/torquebox/jboss/bin/standalone.sh \
        -Djboss.server.log.dir=${JBOSS_LOG_DIR} \
        -Dhttp.port=${RAZOR_HTTP_PORT} \
        -Dhttps.port=${RAZOR_HTTPS_PORT} \
        -b 0.0.0.0

