mail-server-admin
=================

A collection of scripts to assist in administering a Postfix/Dovecot mail server.

create-user.sh
--------------
Create new user. Set up for virtual users (not system users) with no SQL DB.

Usage: ./create-user.sh

Requires: run as root

TODO:
- check for existing users
- add alias creation at same time