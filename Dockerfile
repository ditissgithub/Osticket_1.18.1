FROM almalinux:8.9

LABEL maintainer="satishg@cdac.in"

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm  && \
    dnf -y install yum-utils && \
    dnf module reset php && \
    dnf module install -y php:remi-8.2 && \
    dnf clean all

# Install osTicket packages

RUN sudo yum -y install curl wget unzip vim && \
    curl -s https://api.github.com/repos/osTicket/osTicket/releases/latest \
    | grep browser_download_url \
    | grep "browser_download_url" \
    | cut -d '"' -f 4 \
    | wget -i - && \
    unzip osTicket-v*.zip -d osTicket && \
    sudo mv osTicket /var/www/ && \
    sudo cp /var/www/osTicket/upload/include/ost-sampleconfig.php /var/www/osTicket/upload/include/ost-config.php


#CMD [ entrypoint.sh ]
CMD ["/bin/bash"]
