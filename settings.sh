SRC=/opt/src/mo

### Docker settings.
IMAGE=moodle
CONTAINER=moodle
#PORTS="80:80 443:443 2222:22"
PORTS=""

DOMAIN="moodle.example.org"

#CONFIG="set_prompt mount_tmp_on_ram ssmtp mysql apache2 get_ssl_cert phpmyadmin"
CONFIG="set_prompt mount_tmp_on_ram ssmtp mysql apache2"

### MySQL settings
DBNAME=moodle
DBUSER=moodle
DBPASS=moodle

### Gmail account for notifications.
### Make sure to enable less-secure-apps:
### https://support.google.com/accounts/answer/6010255?hl=en
GMAIL_ADDRESS=
GMAIL_PASSWD=

### Moodle site settings.
SITE_LANG=en
SITE_FULLNAME=
SITE_SHORTNAME=

### Admin settings.
ADMIN_USER=admin
ADMIN_PASS=
ADMIN_EMAIL=

### Settings for register/login with OAuth2.
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

### Settings for the module offlinequiz.
OFFLINEQUIZ_LOGOURL=
