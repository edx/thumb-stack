#!/bin/bash

if [ -d thumb ]; then
    echo "The thumb directory already exists, will reuse contents"
else
    echo "Creating the thumb directory"
    mkdir thumb
fi

if [ -f thumb/Vagrantfile ]; then
    echo "thumb/Vagrantfile already exists"
else
    echo "Copying Vagrantfile"
    curl -L https://raw.githubusercontent.com/edx/configuration/master/vagrant/release/devstack/Vagrantfile > thumb/Vagrantfile
fi

if [ -f thumb/cypress-devstack.box ]; then
    echo "thumb/cypress-devstack.box already exists"
else
    echo "Copying Cypress box"
    curl -L http://files.edx.org/vagrant-images/cypress-devstack.box > thumb/cypress-devstack.box
fi

if [ -d thumb/edx-platform-bare ]; then
    echo "thumb/edx-platform-bare already exists"
else
    echo "Cloning edx-platform"
    git clone --bare https://github.com/edx/edx-platform.git thumb/edx-platform-bare
    rm thumb/edx-platform-bare/hooks/*.sample
fi

if [ -d thumb/cs_comments_service-bare ]; then
    echo "thumb/cs_comments_service-bare already exists"
else
    echo "Cloning cs_comments_service"
    git clone --bare https://github.com/edx/cs_comments_service.git thumb/cs_comments_service-bare
    rm thumb/cs_comments_service-bare/hooks/*.sample
fi

echo "Copying static files"
cp -v static/* thumb
chmod +x thumb/install.sh

echo ""
echo "The thumb directory contains all the files that should be copied to the thumb drive."
echo "For example, with:"
echo "    cp -R thumb/* '/Volumes/OPEN EDX/'"
