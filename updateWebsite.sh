#!/bin/bash

cp -r /home/http/website-control/* /srv/http/
chown -R root:root /srv/http/
chmod -R 755 /srv/http

