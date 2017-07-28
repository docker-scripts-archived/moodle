APP=moodle

### Docker settings.
IMAGE=moodle
CONTAINER=moodle1-example-org
#PORTS="80:80 443:443 2222:22"    ## ports to be forwarded when running stand-alone
PORTS=""    ## no ports to be forwarded when running behind wsproxy

DOMAIN="moodle1.example.org"

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
