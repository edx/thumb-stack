#!/bin/bash
#
# Install script for Open edX thumb-stack.
# The latest version of this file is at:
# https://github.com/edx/thumb-stack/blob/master/static/install.sh

if [ ! -x "$(command -v git)" ]; then
    echo "You must install git"
    exit 1
fi

if [ ! -x "$(command -v vagrant)" ]; then
    echo "You must install vagrant"
    exit 1
fi

THUMB=$(dirname "$0")

echo "Thumb drive is $THUMB"

if [ ! -f "$THUMB/cypress-devstack.box" ]; then
    echo "There's no cypress-devstack.box on the thumb drive?"
    exit 1
fi

export OPENEDX_RELEASE=named-release/cypress
vagrant box add "$THUMB/cypress-devstack.box" --name=cypress-devstack
mkdir devstack
cd devstack
cp "$THUMB/Vagrantfile" .
vagrant up --no-provision
git clone "$THUMB/edx-platform-bare" edx-platform
git -C edx-platform remote set-url origin https://github.com/edx/edx-platform.git
git clone "$THUMB/cs_comments_service-bare" cs_comments_service
git -C cs_comments_service remote set-url origin https://github.com/edx/cs_comments_service.git
vagrant provision
