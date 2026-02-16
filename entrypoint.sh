#!/bin/sh
## vnc :10 must be aligned with /etc/tigervpc/vncserver.users
/usr/libexec/tigervncsession-start :10
## rdp
/usr/sbin/xrdp-sesman
exec /usr/sbin/xrdp --nodaemon
exec /usr/bin/sleep infinity
