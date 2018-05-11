#!/bin/bash -ex

function command_exists {
  type "$1" &> /dev/null
}

function install_memcache() {
  echo "memcached not found, trying to install"
  cd /tmp
  wget http://www.memcached.org/files/memcached-1.5.7.tar.gz
  tar -zxf memcached-1.5.7.tar.gz
  cd memcached-1.5.7
  ./configure && make && make test && sudo make instal
}

if ! command_exists "memcached -V"; then
   install_memcache
fi
