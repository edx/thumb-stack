# Open edX Quick Start Thumb Drive

The files on this thumb drive will help you get started with development on
Open edX.  Included are:

- A vagrant image of a development machine
- A clone of edx-platform, the largest edX repo
- This README


# Byte Sized bugs: 

http://bit.ly/edxbugs


# Installing Open edX from a flash drive on OS X

- Install homebrew cask, which lets you install vagrant and virtualbox:

`brew install caskroom/cask/brew-cask`
`brew cask install vagrant virtualbox`

- Plug in the flash drive and run:
`vagrant box add '/Volumes/Open EDX/birch-devstack.box' --name=birch-devstack`

This copies and decompresses a full Ubuntu virtual machine with Open edX
installed and ready to run onto your computer, so it will take a few minutes.
(Much faster than downloading on conference wifi, though :)

- Set this environment variable to make sure we'll be using the birch release,
  rather than the default: `export OPENEDX_RELEASE=named-release/birch`

Note that `vagrant ssh` will later require this variable, so repeat this step in every shell you open.

- Follow the directions at https://github.com/edx/configuration/wiki/edX-Developer-Stack#installing-the-edx-developer-stack (copied below):

```
mkdir devstack
cd devstack
curl -L https://raw.githubusercontent.com/edx/configuration/master/vagrant/release/devstack/Vagrantfile > Vagrantfile
vagrant plugin install vagrant-vbguest
vagrant up
```

`vagrant up` will take about 20 minutes the first time.

- Once it's finished, `vagrant ssh` to log in!

- Within the vagrant box, `sudo su edxapp` (switch to user "edxapp")
- Start up the learning management system (the student-facing web app): `paver devstack lms`

Open a browser to `localhost:8000` to view the site!

- Open a new shell, then:
    - `export OPENEDX_RELEASE=named-release/birch`
    - `vagrant ssh`
    - `sudo su edxapp`
    - `paver devstack studio` to start up the instructor-facing app

Open a browser to `localhost:8001` to view the instructor-facing site!

(lolz: mostly a duplicate of https://github.com/edx/configuration/wiki/edX-Developer-Stack#using-the-edx-devstack )

in order to start the forums service, run:
`sudo su forum`
`bundle install`
`ruby app.rb -p 18080`

Updating to Master on your devstack:
As the `vagrant` user:
`sudo /edx/bin/update configuration master`
# If this fails because of password vault, just run it again.
`sudo /edx/bin/update edx-platform master`


Connecting your devstack to your fork:
On the host machine in the edx-platform repo 

Running Migrations on devstack:
`python manage.py lms --settings=devstack migrate`







### How to create the thumbdrive

mkdir OpenEdxThumb
cd OpenEdxThumb
curl -L https://raw.githubusercontent.com/edx/configuration/master/vagrant/release/devstack/Vagrantfile > Vagrantfile
curl -L http://files.edx.org/vagrant-images/20150224-birch-devstack.box > birch-devstack.box
git clone --bare https://github.com/edx/edx-platform.git edx-platform-bare
git clone --bare https://github.com/edx/cs_comments_service.git cs_comments_service-bare
cat >install.sh <<END_INSTALL
#!/bin/bash

THUMB=$(dirname "$0")

echo "Thumb drive is $THUMB"

if [ ! -f "$THUMB/birch-devstack.box" ]; then
    echo "There's no birch-devstack.box there"
    exit 1
fi

VAGRANT=$(which vagrant)

if [ -z "$VAGRANT" ]; then
    echo "You must install vagrant first"
    exit 1
fi

export OPENEDX_RELEASE=named-release/birch
vagrant box add "$THUMB/birch-devstack.box" --name=birch-devstack
mkdir devstack
cd devstack
cp "$THUMB/Vagrantfile" .
vagrant up --no-provision
git clone "$THUMB/edx-platform-bare" edx-platform
git -C edx-platform remote set-url origin https://github.com/edx/edx-platform.git
git clone "$THUMB/cs_comments_service-bare" cs_comments_service
git -C cs_comments_service remote set-url origin https://github.com/edx/cs_comments_service.git
vagrant provision
END_INSTALL
chmod +x install.sh


### Cleaning up between tests
cd devstack
vagrant destroy
cd ..
vagrant box remove birch-devstack
rm -rf devstack


new: 9m48s
old: 12m47s
