#!/bin/bash

# 1. Copy hiera.conf from /vagrant to /etc/puppetlabs/puppet
# 2. Sync /vagrant/manifests with /etc/puppetlabs/puppet/manifests
# 3. Sync /vagrant/modules with /etc/puppetlabs/puppet/modules
# 4. sync /vagrant/hieradata with /etc/puppetlabs/puppet/hieradata

red='\e[0;31m'
orange='\e[0;33m'
green='\e[0;32m'
end='\e[0m'

cd /vagrant

echo -e "----> ${green}Copy hiera configuration${end}"
cp hiera.yaml /etc/puppetlabs/puppet/

echo -e "----> ${green}Sync manifests${end}"
rsync -avzh manifests/ /etc/puppetlabs/puppet/environments/production/manifests

echo -e "----> ${green}Sync modules${end}"
rsync -avzh modules/ /etc/puppetlabs/puppet/environments/production/modules

echo -e "----> ${green}Sync hieradata${end}"
mkdir -p /etc/puppetlabs/puppet/hieradata
rsync -avzh hieradata/ /etc/puppetlabs/puppet/hieradata
