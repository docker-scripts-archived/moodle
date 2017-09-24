FROM ubuntu:16.04
ENV container docker
# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target
CMD ["/sbin/init"]

### Update and upgrade and install some other packages.
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install cron vim git wget curl unzip \
               rsyslog logrotate ssmtp logwatch

### Install packages required by moodle.
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
            sudo apache2 mysql-client mysql-server graphviz aspell \
            php7.0 libapache2-mod-php7.0 php7.0-pspell php7.0-curl \
            php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc \
            php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring

### Install moosh (http://moosh-online.com/)
RUN apt-get -y install composer
RUN git clone git://github.com/tmuras/moosh.git /usr/local/src/moosh && \
    cd /usr/local/src/moosh && \
    composer install && \
    ln -s /usr/local/src/moosh/moosh.php /usr/local/bin/moosh

### Get moodle code from git.
#RUN git clone --progress --verbose git://git.moodle.org/moodle.git /usr/local/src/moodle
RUN git clone --progress --verbose https://github.com/moodle/moodle /usr/local/src/moodle
