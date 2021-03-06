#!/bin/bash
#sudo yum -y install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
#sudo yum -y install git
sudo yum --disableplugin=fastestmirror update
cd /etc/puppetlabs/code/environments/vagrant
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
/opt/puppetlabs/bin/puppet apply ./manifests/ --environment vagrant --hiera_config ./hiera.yaml