echo off
echo Windows Open edX thumb drive installer
echo Thumb drive is %~dp0

set OPENEDX_RELEASE=named-release/birch
set VAGRANT_USE_VBOXFS=true

echo Adding birch vagrant box...
REM Seems like vagrant can only add this box from the current directory.
pushd %~dp0
REM vagrant box add birch-devstack.box --name=birch-devstack
popd

if not exist devstack mkdir devstack
cd devstack
echo Copying Vagrantfile...
copy %~dp0\Vagrantfile .

echo Starting vagrant...
REM vagrant up --no-provision

echo Cloning git repos...
git clone "%~dp0/edx-platform-bare" edx-platform
git -C edx-platform remote set-url origin https://github.com/edx/edx-platform.git
git clone "%~dp0/cs_comments_service-bare" cs_comments_service
git -C cs_comments_service remote set-url origin https://github.com/edx/cs_comments_service.git

echo Fixing symlinks...
echo git config --global alias.add-symlink '!__git_add_symlink(){ dst=$(echo "$2")/../$(echo "$1"); if [ -e "$dst" ]; then hash=$(echo "$1" ^| git hash-object -w --stdin); git update-index --add --cacheinfo 120000 "$hash" "$2"; git checkout -- "$2"; else echo "ERROR: Target $dst does not exist!"; echo "       Not creating invalid symlink."; fi; }; __git_add_symlink "$1" "$2"' > fixsymlinks.sh
echo git config --global alias.rm-symlink '!__git_rm_symlink(){ git checkout -- "$1"; link=$(echo "$1"); POS=$'\''/'\''; DOS=$'\''\\\\'\''; doslink=${link//$POS/$DOS}; dest=$(dirname "$link")/$(cat "$link"); dosdest=${dest//$POS/$DOS}; if [ -f "$dest" ]; then rm -f "$link"; cmd //C mklink //H "$doslink" "$dosdest"; elif [ -d "$dest" ]; then rm -f "$link"; cmd //C mklink //J "$doslink" "$dosdest"; else echo "ERROR: Something went wrong when processing $1 . . ."; echo "       $dest may not actually exist as a valid target."; fi; }; __git_rm_symlink "$1"' >> fixsymlinks.sh
echo git config --global alias.rm-symlinks '!__git_rm_symlinks(){ for symlink in `git ls-files -s ^| grep -E "^120000" ^| cut -f2`; do git rm-symlink "$symlink"; git update-index --assume-unchanged "$symlink"; done; }; __git_rm_symlinks' >> fixsymlinks.sh
echo git config --global alias.checkout-symlinks '!__git_checkout_symlinks(){ POS=$'\''/'\''; DOS=$'\''\\\\'\''; for symlink in `git ls-files -s ^| grep -E "^120000" ^| cut -f2`; do git update-index --no-assume-unchanged "$symlink"; if [ -d "$symlink" ]; then dossymlink=${symlink//$POS/$DOS}; cmd //C rmdir //S //Q "$dossymlink"; fi; git  checkout -- "$symlink"; echo "Restored git symlink $symlink <<===>> `cat $symlink`"; done; }; __git_checkout_symlinks' >> fixsymlinks.sh
echo git -C %cd%\edx-platform rm-symlinks >> fixsymlinks.sh

pushd .
cygwin < fixsymlinks.sh
popd

del fixsymlinks.sh

echo Provisioning vagrant...
REM vagrant provision
