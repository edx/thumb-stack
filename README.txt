Thumb-Stack
~~~~~~~~~~~

Scripts to create a thumb drive with devstack installation files on it.  This
stages all the files in a directory called "thumb".  Then you can copy those
files to a thumb drive, or many thumb drives.

To create a thumb drive:

1. Run make_thumb.sh in this directory::

    $ ./make_thumb.sh

2. This creates the "thumb" directory here.  Copy all of the files from thumb
   to your thumb drive:

    $ cp -R thumb/* '/Volumes/OPEN EDX/'

3. The thumb drive has a README.txt that explains what to do with it.

To create another thumb drive, there's no need to repeat step 1.  Just copy
the files in step 2 again.


Testing the install
-------------------

After running the thumb drive install.sh, you'll need to clean up before you
can run it again in a realistic scenario::

    $ cd devstack
    $ vagrant destroy
    $ cd ..
    $ rm -rf devstack
    $ vagrant box remove cypress-devstack
