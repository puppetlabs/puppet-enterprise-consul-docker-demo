#!/bin/bash

# 1. Copy hiera.conf from /vagrant to /etc/puppetlabs/puppet

red='\e[0;31m'
orange='\e[0;33m'
green='\e[0;32m'
end='\e[0m'

cd /vagrant

echo -e "----> ${green}Copy hiera configuration${end}"
cp hiera.yaml /etc/puppetlabs/puppet
