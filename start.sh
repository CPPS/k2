#!/bin/bash

sudo /etc/init.d/postgresql-9.5 start
sudo /etc/init.d/redis start

exec ~/.gem/ruby/2.3.0/bin/foreman start
