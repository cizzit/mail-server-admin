#!/bin/sh
# Author: Stuart Rowe <stuart@localghost.com.au>
# Date: 23/04/2014

# Assist in auto creating virtual users in postfix and dovecot
# TODO: check for existing users in virtual-mailbox-users and virtual

# Step 1. Set variables

domainname=DOMAINNAMEGOESHERE
postfixpath=/etc/postfix
dovecotpath=/etc/dovecot

# Step 2. Get user input.
# Need: username, password
read -p "Enter your username (will be USERNAME@$domainname) " username
read -p "Enter your desired password: " pass1
read -p "Confirm your password: " pass2

if [ $pass1 = $pass2 ]; then
        echo Updating configuration files...
else
        echo Password dont match!
        exit 1 #password mismatch
fi

# Step 3. Edit some files

# edit: $pathprefix/etc/postfix/virtual-mailbox-users
# add: $username@$domainname    $username@$domainname
# save:
# run: postmap $pathprefix/etc/postfix/virtual-mailbox-users
echo $username@$domainname $username@$domainname >> $postfixpath/virtual-mailbox-users
postmap $postfixpath/virtual-mailbox-users


# edit: $pathprefix/etc/postfix/virtual
# add: $username@$domainname $username@$domainname
# save:
# run: postmap $pathprefix/etc/postfix/virtual
echo $username@$domainname $username@$domainname >> $postfixpath/virtual
postmap $postfixpath/virtual

# edit: $pathprefix/etc/dovecot/passwd.db
# add: doveadm pw -s SSHA512 -p $pass1
# save:
passhash=`doveadm pw -s SSHA512 -p $pass1`
echo $username@$domainname:$passhash >> $dovecotpath/passwd.db

echo Configuration files updated, restarting services...

# Step 4. restart services
# service postfix restart
# service dovecot restart

echo Services restarted. Process complete.