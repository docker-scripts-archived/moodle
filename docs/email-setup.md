
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

To install a simple SMTP server, follow the instructions here:
https://github.com/docker-scripts/postfix/blob/master/INSTALL.md
(or here: http://dashohoxha.fs.al/simple-smtp-server/).

You can set the SMTP settings with one of these alternatives:

- Set **SMTP_SERVER** on `settings.sh`, like this:
  ```
  ### You can build an SMTP server as described here:
  ### https://github.com/docker-scripts/postfix/blob/master/INSTALL.md
  SMTP_SERVER=smtp.example.org
  SMTP_DOMAIN=example.org
  ```

- From the command line:
  ```
  moosh config-set smtphosts smtp.example.org
  moosh config-set smtpsecure TLS
  moosh config-set smtpauthtype PLAIN
  moosh config-set smtpuser ''
  moosh config-set smtppass ''
  moosh config-set smtpmaxbulk 100
  ```

- From the admin interface (as described on the previous section):
  - **SMTP hosts**: `smtp.example.org`
  - **SMTP security**: `TLS`
  - **SMTP Auth Type**: `PLAIN`
  
  Leave empty username and password.
