APP=moodle
MOODLE_BRANCH=MOODLE_36_STABLE

### Docker settings.
IMAGE=dockerscripts/moodle
CONTAINER=moodle1-example-org
#PORTS=

DOMAIN="moodle1.example.org"

### MySQL settings
DBNAME=moodle
DBUSER=moodle
DBPASS=moodle

### You can build an SMTP server as described here:
### https://github.com/docker-scripts/postfix/blob/master/INSTALL.md
### Comment out if you don't have a SMTP server and want to use
### a gmail account, as described below.
SMTP_SERVER=smtp.example.org
SMTP_DOMAIN=example.org

### Gmail account for notifications. Use this as a simple alternative to building
### your own SMTP server. However this has some limitations, as described here:
### https://github.com/docker-scripts/moodle/blob/master/docs/email-setup.md
### You need to create an application specific password for your account:
### https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882
GMAIL_ADDRESS=
GMAIL_PASSWD=

### Moodle site settings.
SITE_LANG=en
SITE_FULLNAME="Moodle Example 1"
SITE_SHORTNAME="MDL1"

### Admin settings.
ADMIN_USER=admin
ADMIN_PASS="admin-1234"
ADMIN_EMAIL=admin@example.org

### Settings for register/login with OAuth2.
### See: https://developers.google.com/adwords/api/docs/guides/authentication#webapp
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

### Additional plugins to be installed.
PLUGINS="
    mod_bigbluebuttonbn
    mod_recordingsbn
    mod_offlinequiz
    qbehaviour_adaptive_adapted_for_coderunner
    qtype_coderunner
    atto_mathslate
    tinymce_mathslate
    mod_webrtcexperiments
"

### Settings for the plugin offlinequiz.
OFFLINEQUIZ_LOGOURL=
