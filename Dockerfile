### Latest Moodle: 3.5.3+

FROM ubuntu:18.04

### install systemd
RUN apt update && \
    apt upgrade --yes && \
    apt install --yes systemd && \
    systemctl set-default multi-user.target

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
WORKDIR /host

RUN apt install --yes locales rsyslog logrotate cron logwatch ssmtp vim

### Update and upgrade and install some other packages.
RUN apt install --yes git wget curl unzip

### Install mariadb
RUN apt install --yes software-properties-common && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 && \
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://ftp.utexas.edu/mariadb/repo/10.2/ubuntu artful main' && \
    apt update
RUN DEBIAN_FRONTEND=noninteractive \
    apt install --yes mariadb-server mariadb-client

### Install packages required by moodle.
RUN DEBIAN_FRONTEND=noninteractive \
    apt install --yes \
        sudo apache2 graphviz aspell \
        php7.2 libapache2-mod-php7.2 php7.2-pspell php7.2-curl \
        php7.2-gd php7.2-intl php7.2-mysql php7.2-xml php7.2-xmlrpc \
        php7.2-ldap php7.2-zip php7.2-soap php7.2-mbstring

### Install moosh (http://moosh-online.com/)
RUN apt install --yes composer
RUN git clone git://github.com/tmuras/moosh.git /usr/local/src/moosh && \
    cd /usr/local/src/moosh && \
    composer install && \
    ln -s /usr/local/src/moosh/moosh.php /usr/local/bin/moosh

### Get moodle code from git.
#RUN git clone --progress --verbose git://git.moodle.org/moodle.git /usr/local/src/moodle
RUN git clone --progress --verbose https://github.com/moodle/moodle /usr/local/src/moodle
