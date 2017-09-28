#!/bin/bash -x
### moodle configuration

$moosh auth-manage enable oauth2
$moosh auth-manage up oauth2

### get $DBNAME,  $GOOGLE_CLIENT_ID, $GOOGLE_CLIENT_SECRET
source /host/settings.sh

[[ -n $GOOGLE_CLIENT_ID ]] || exit

timestamp=$(date +%s)

$mysql --database=$DBNAME -B -e "
    INSERT INTO mdl_oauth2_issuer
        (id, timecreated, timemodified, usermodified, name, image, baseurl,
        clientid, clientsecret, loginscopes, loginscopesoffline, loginparams,
        loginparamsoffline, alloweddomains, scopessupported, enabled, showonloginpage,
        sortorder)
    VALUES
        (1, $timestamp, $timestamp, 2, 'Google', 'https://accounts.google.com/favicon.ico',
        'http://accounts.google.com/', '$GOOGLE_CLIENT_ID', '$GOOGLE_CLIENT_SECRET',
        'openid profile email', 'openid profile email', '', 'access_type=offline&prompt=consent',
        '', 'openid email profile', 1, 1, 0);
    "

$mysql --database=$DBNAME -B -e "
    INSERT INTO mdl_oauth2_endpoint
        (id, timecreated, timemodified, usermodified, name, url, issuerid)
    VALUES
        (1, $timestamp, $timestamp, 2, 'discovery_endpoint', 'https://accounts.google.com/.well-known/openid-configuration', 1),
        (2, $timestamp, $timestamp, 2, 'authorization_endpoint', 'https://accounts.google.com/o/oauth2/v2/auth', 1),
        (3, $timestamp, $timestamp, 2, 'token_endpoint', 'https://www.googleapis.com/oauth2/v4/token', 1),
        (4, $timestamp, $timestamp, 2, 'userinfo_endpoint', 'https://www.googleapis.com/oauth2/v3/userinfo', 1),
        (5, $timestamp, $timestamp, 2, 'revocation_endpoint', 'https://accounts.google.com/o/oauth2/revoke', 1);
    "

$mysql --database=$DBNAME -B -e "
    INSERT INTO mdl_oauth2_user_field_mapping
        (id, timemodified, timecreated, usermodified, issuerid, externalfield, internalfield)
    VALUES
        (1, $timestamp, $timestamp, 2, 1, 'given_name', 'firstname'),
        (2, $timestamp, $timestamp, 2, 1, 'middle_name', 'middlename'),
        (3, $timestamp, $timestamp, 2, 1, 'family_name', 'lastname'),
        (4, $timestamp, $timestamp, 2, 1, 'email', 'email'),
        (5, $timestamp, $timestamp, 2, 1, 'website', 'url'),
        (6, $timestamp, $timestamp, 2, 1, 'nickname', 'alternatename'),
        (7, $timestamp, $timestamp, 2, 1, 'picture', 'picture'),
        (8, $timestamp, $timestamp, 2, 1, 'address', 'address'),
        (9, $timestamp, $timestamp, 2, 1, 'phone', 'phone1'),
        (10, $timestamp, $timestamp, 2, 1, 'locale', 'lang');
    "
