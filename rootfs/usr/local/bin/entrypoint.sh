#!/usr/bin/env bash

exec su-exec $UID:$GID /bin/s6-svscan /etc/s6.d
