
Sending notification messages is an important feature of Moodle.
To enable this we need to supply the settings of a SMTP server.
The most easy way is to use a Gmail account, as described here:
https://docs.moodle.org/35/en/Email_setup_gmail

**Note:** Somehow it is not possible to access the SMTP settings
anymore on the path `Settings > Site administration > Plugins >
Message outputs > Email`, as suggested by this page. Instead go to
`Dashboard > Site administration` and search for `email`. Or go
directly to this url on the browser: `/admin/search.php?query=email`,
or to this one: `/admin/category.php?category=email`.

Here you can set these settings (as suggested by the document page):
- **SMTP hosts**: `smtp.gmail.com:465`
- **SMTP security**: `SSL`
- **SMTP username**: Your email address @gmail.com
- **SMTP password**: password for the above email account

Another easier way is to set these lines on `settings.sh`, before
building (or re-building) the container:
```
### Gmail account for notifications. This will be used by ssmtp.
### You need to create an application specific password for your account:
### https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882
GMAIL_ADDRESS='account@gmail.com'
GMAIL_PASSWD='gmail-password-of-this-account'
```

However, as described on the Moodle doc page, using Gmail accounts has
some limitations (for example a daily limit of 500 messages). So we
will also see how to build our own mailserver, which can be used to
send email notifications from our Moodle site(s). It needs some more
work, but usually it is worth doing it.

## Building a simple mailserver

We are going to use this docker based mailserver:
https://github.com/tomav/docker-mailserver We don't need to check for
spam or viruses, we just need a simple mailserver to send emails from
our applications (in this case from Moodle).


- First create a directory for the mailserver and get the setup script:
  ```
  mkdir -p /var/ds/mail.example.org
  cd /var/ds/mail.example.org/

  curl -o setup.sh \
      https://raw.githubusercontent.com/tomav/docker-mailserver/master/setup.sh
  chmod a+x ./setup.sh
  ```

- Create the file `docker-compose.yml` with a content like this:
  ```
  version: '2'

  services:
    mail:
      image: tvial/docker-mailserver:latest
      hostname: mail
      domainname: example.org
      container_name: mail
      ports:
      - "25:25"
      - "587:587"
      - "465:465"
      volumes:
      - ./data/:/var/mail/
      - ./state/:/var/mail-state/
      - ./config/:/tmp/docker-mailserver/
      - /var/ds/wsproxy/letsencrypt/:/etc/letsencrypt/
      environment:
      - PERMIT_DOCKER=network
      - SSL_TYPE=letsencrypt
      - ONE_DIR=1
      - DMS_DEBUG=1
      - SPOOF_PROTECTION=0
      - REPORT_RECIPIENT=1
      - ENABLE_SPAMASSASSIN=0
      - ENABLE_CLAMAV=0
      - ENABLE_FAIL2BAN=1
      - ENABLE_POSTGREY=0
      cap_add:
      - NET_ADMIN
      - SYS_PTRACE
  ```
  
  For for details about the environment variables that can be used,
  and their meaning and possible values, check also these:
  - https://github.com/tomav/docker-mailserver#environment-variables
  - https://github.com/tomav/docker-mailserver/blob/master/.env.dist
  
  Make sure to set the propper `domainname` that you will use for the
  emails. We forward only SMTP ports (not POP3 and IMAP) because we
  are not interested in accessing the mailserver directly (from a
  client).  We also use these settings:
  - `PERMIT_DOCKER=network` because we want to send emails from other
    docker containers.
  - `SSL_TYPE=letsencrypt` because we will manage SSL certificates
    with letsencrypt.

- We need to open these ports on the firewall: `25`, `587`, `465`
  ```
  ufw allow 25
  ufw allow 587
  ufw allow 465
  ```
  On your server you may have to do it differently.

- Pull the docker image:
  ```
  docker pull tvial/docker-mailserver:latest
  ```

- Now generate the DKIM keys with `./setup.sh config dkim` and copy
  the content of the file `config/opendkim/keys/domain.tld/mail.txt`
  on the domain zone configuration at the DNS server. I use
  [bind9](https://github.com/docker-scripts/bind9) for managing my
  domains, so I just paste it on `example.org.db`:
  ```
  mail._domainkey IN      TXT     ( "v=DKIM1; h=sha256; k=rsa; "
          "p=MIIBIjANBgkqhkiG9w0BAQEFACAQ8AMIIBCgKCAQEAaH5KuPYPSF3Ppkt466BDMAFGOA4mgqn4oPjZ5BbFlYA9l5jU3bgzRj3l6/Q1n5a9lQs5fNZ7A/HtY0aMvs3nGE4oi+LTejt1jblMhV/OfJyRCunQBIGp0s8G9kIUBzyKJpDayk2+KJSJt/lxL9Iiy0DE5hIv62ZPP6AaTdHBAsJosLFeAzuLFHQ6USyQRojefqFQtgYqWQ2JiZQ3"
          "iqq3bD/BVlwKRp5gH6TEYEmx8EBJUuDxrJhkWRUk2VDl1fqhVBy8A9O7Ah+85nMrlOHIFsTaYo9o6+cDJ6t1i6G1gu+bZD0d3/3bqGLPBQV9LyEL1Rona5V7TJBGg099NQkTz1IwIDAQAB" )  ; ----- DKIM key mail for example.org

  ```

- Add these configurations as well on the same file on the DNS server:
  ```
  mail      IN  A   10.11.12.13
  
  ; mailservers for example.org
      3600  IN  MX  1  mail.example.org.
  
  ; Add SPF record
            IN TXT "v=spf1 mx ~all"
  ```
  Then don't forget to change the serial number and to restart the service.

- Get an SSl certificate from letsencrypt. I use
  [wsproxy](https://github.com/docker-scripts/wsproxy) for managing
  SSL letsencrypt certificates of my domains:
  ```
  cd /var/ds/wsproxy
  ds domains-add mail mail.example.org
  ds get-ssl-cert myemail@gmail.com mail.example.org --test
  ds get-ssl-cert myemail@gmail.com mail.example.org
  ```
  Now the certificates will be available on
  `/var/ds/wsproxy/letsencrypt/live/mail.example.org`.

- Start the mailserver and check for any errors:
  ```
  apt install docker-compose
  docker-compose up mail
  ```

- Create email accounts and aliases:
  ```
  ./setup.sh email add admin@example.org passwd123
  ./setup.sh email add info@example.org passwd123
  ./setup.sh alias add admin@example.org myemail@gmail.com
  ./setup.sh alias add info@example.org myemail@gmail.com
  ./setup.sh email list
  ./setup.sh alias list
  ```
  
  Aliases make sure that any email that comes to these accounts is
  forwarded to my real email address, so that I don't need to use
  POP3/IMAP in order to get these messages. Also no anti-spam and
  anti-virus software is needed, making the mailserver lighter.

- Send some test emails to these addreses and make other tests. Then
  stop the container with `Ctrl+c` and start it again as a daemon:
  `docker-compose up mail -d`.

- Now save on Moodle configuration the SMTP settings and test by
  trying to send some messages to other users:
  - **SMTP hosts**: `mail.example.org:465`
  - **SMTP security**: `SSL`
  - **SMTP username**: info@example.org
  - **SMTP password**: passwd123
