
FROM alpine:3.11

RUN apk --no-cache add dnsmasq

ADD deps/ipxe/undionly.kpxe  /var/tftpboot/
ADD deps/ipxe/ipxe.efi       /var/tftpboot/

ADD dnsmasq_trinity.conf     /etc/dnsmasq.d/

ENTRYPOINT ["dnsmasq", "-d"]

