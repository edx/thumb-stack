#!/bin/bash

mkdir thumb

echo "Copying Vagrantfile"
curl -L https://raw.githubusercontent.com/edx/configuration/master/vagrant/release/devstack/Vagrantfile > thumb/Vagrantfile

echo "Copying Birch box"
curl -L http://files.edx.org/vagrant-images/20150224-birch-devstack.box > thumb/birch-devstack.box

echo "Cloning edx-platform"
git clone --bare https://github.com/edx/edx-platform.git thumb/edx-platform-bare

echo "Cloning cs_comments_service"
git clone --bare https://github.com/edx/cs_comments_service.git thumb/cs_comments_service-bare

echo "Copying static files"
cp static/* thumb
chmod +x thumb/install.sh

echo "The thumb directory contains all the files that should be copied to the thumb drive."
