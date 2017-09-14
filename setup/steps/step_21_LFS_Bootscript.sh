#!/bin/bash

# user enable to run script :: "root:"

if [ "$(echo $LFS)" = "" ]; then
	printf "\033[31m[ { ✗ }ERROR  ] LFS variable not present. Check step 1\033[0m\n"
	exit 1
else
	printf "\033[32m[ { ✓ }SUCCESS ] LFS variable was set successfully\033[0m\n"
fi 


pkg_source="lfs-bootscripts-20170626.tar.bz2"
pkg_path="/sources/lfs-bootscripts-20170626.tar.bz2"

pkg_name="$(basename $(tar -tf $pkg_path | head -n 1 | cut -d'/' -f 1))"

base_dir="/sources"
log_file="/logs/"$(echo $pkg_name)".log"

status=0

setup(){
	cd $base_dir							|| return
	tar -xf $pkg_source						|| return
	cd $pkg_name							|| return
}

build(){
	make install							|| return
}

teardown(){
	cd $base_dir
	rm -rfv $pkg_name
}

# Internal process

if [ $status -eq 0 ]; then
	setup >> $log_file 2>&1
	status=$?
fi

if [ $status -eq 0 ]; then
	build >> $log_file 2>&1
	status=$?
fi

if [ $status -eq 0 ]; then
	teardown >> $log_file 2>&1
	status=$?
fi

if [ $status -eq 0 ]; then
	printf "\033[32m[ { ✓ }SUCCESS ] \033[0m\n"
else
	printf "\033[31m[ { ✗ }ERROR ] \033[0m\n"
fi

exit $status