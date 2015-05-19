################################
Open edX Quick Start Thumb Drive
################################

(The latest version of this file is at https://github.com/edx/thumb-stack/blob/master/static/README.txt)

The files on this thumb drive will help you get started with development on
Open edX.  Included are:

- A vagrant image of a development machine
- Two required edX GitHub repos
- Scripts that can install the contents of the thumb drive
- This README.txt

Installation happens in two steps:

1. Install the prerequisites (Vagrant, VirtualBox and Git) onto your machine.
2. Use the install script on this thumb drive to install Open edX.


Installing prerequisites on OS X
================================

If you don't have Homebrew installed, visit http://brew.sh/ for instructions
to install it.

Install homebrew cask, which lets you install vagrant and virtualbox::

    $ brew install caskroom/cask/brew-cask
    $ brew cask install vagrant virtualbox
    $ vagrant plugin install vagrant-vbguest

Installing prerequisites on Windows
===================================

You will need to have a number of prerequisites installed:

    * Git
    * Vagrant
    * VirtualBox
    * Cygwin

Each of these has a Windows installer available on their web site.  The new
Chocolatey package manager for Windows also does a good job installing them if
it is available on your version of Windows.


Installing Open edX from the thumb drive
========================================

The thumb drive has scripts that will install everything.  Which script you use
depends on your operating system.  If the install script doesn't work for some
reason, you can resort to manual steps, explained further below.

Installing on Mac or Linux
--------------------------

In a terminal window:

1. Choose a directory where you want the devstack files to live, and cd there::

    $ cd /my/dev/directory

2. Run the install.sh file from the thumb drive::

    $ '/Volumes/OPEN EDX/install.sh'

This will take about ten minutes: it copies files, creates the virtual machine,
and so on.

Install on Windows
------------------

In a command prompt:

1. Choose a directory where you want the devstack files to live, and cd there::

    C:> cd \my\dev\directory

2. Run the install.bat file from the thumb drive::

    C:> e:\install.bat

Note that the thumb drive might not be drive E:.  If it isn't, you can use
Windows Explorer to see what drive letter it was assigned.

This will take about ten minutes: it copies files, creates the virtual machine,
and so on.

One special note for PCs: they can have virtualization disabled in the BIOS.
If you find that vagrant can't start the virtual machine, you may need to
reboot into the BIOS settings, and enable virtualization.


Installing manually
-------------------

If the install script doesn't work, or you just like to know what is going on,
you can install files manually from the thumb drive.  In the examples below,
the file path to the thumb drive is shown as '/Volumes/OPEN EDX/'.  You may
need to use a different file path on your machine.

1. Choose a directory where you want the devstack files to live, and cd there::

    $ cd /my/dev/directory

2. Add the vagrant box::

    $ vagrant box add '/Volumes/OPEN EDX/birch-devstack.box' --name=birch-devstack

This copies and decompresses a full Ubuntu virtual machine with Open edX
installed and ready to run onto your computer, so it will take a few minutes.
(Much faster than downloading on conference wifi, though :)

3. Set this environment variable to make sure we'll be using the Birch release,
   rather than the default::

    $ export OPENEDX_RELEASE=named-release/birch

Note that `vagrant ssh` will later require this variable, so repeat this step
in every shell you open.

4. Make the "devstack" directory that will hold the devstack Vagrant files::

    $ mkdir devstack
    $ cd devstack

5. Copy the Vagrantfile from the thumb drive::

    $ cp '/Volumes/OPEN EDX/Vagrantfile' .

6. Start the vagrant image, which can take up to 20 minutes::

    $ vagrant up


More complete manual instructions are at https://github.com/edx/configuration/wiki/edX-Developer-Stack#installing-the-edx-developer-stack
if you need them.


Using the devstack Vagrant image
================================

To use the devstack Vagrant image, you cd to the devstack directory we created
during installation, and use "vagrant ssh" to ssh into the virtual machine::

    $ export OPENEDX_RELEASE=named-release/birch
    $ cd /my/dev/directory/devstack
    $ vagrant up
    $ vagrant ssh

Now you have a command line prompt inside the virtual machine.  A few more
steps, and you will be running the Open edX LMS::

    $ sudo su edxapp
    $ paver devstack lms

Open a browser to `http://localhost:8000` to view the LMS!

To run Studio, the instructor-facing application, open a new terminal window,
then::

    $ export OPENEDX_RELEASE=named-release/birch
    $ vagrant ssh
    $ sudo su edxapp
    $ paver devstack studio

Open a browser to `http://localhost:8001` to view Studio.

To start the forums service, run::

    $ export OPENEDX_RELEASE=named-release/birch
    $ vagrant ssh
    $ sudo su forum
    $ bundle install
    $ ruby app.rb -p 18080

Updating to Master on your devstack::

    $ export OPENEDX_RELEASE=named-release/birch
    $ vagrant ssh
    $ sudo /edx/bin/update configuration master
    # If this fails because of password vault, just run it again.
    $ sudo /edx/bin/update edx-platform master


Useful Resources
================

Byte-Sized bugs, to get started with Open edX development: http://bit.ly/edxbugs

More details of the devstack: https://github.com/edx/configuration/wiki/edX-Developer-Stack
