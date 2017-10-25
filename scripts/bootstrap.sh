#!/bin/bash
GIT_REPO=$1
GIT_BRANCH=$2
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 GIT_REPO GIT_BRANCH"
  exit 1
fi
sudo yum -y install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
sudo yum -y install git
cd /etc/puppetlabs/code/environments
mv production production.orig
git clone ${GIT_REPO} production
cd production
git checkout ${GIT_BRANCH}
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
#/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/
