#!/bin/bash

pkg_source="gettext-0.19.8.1.tar.xz"

pkg_name="$(basename $(tar -tf $1/$pkg_source | head -n 1 | cut -d'/' -f 1))"

base_dir=$1
log_file=$2"/"$(echo $pkg_name)".log"

status=0

setup(){
	cd $base_dir									|| return
	tar -xf $pkg_source								|| return
	cd $pkg_name									|| return
}

build(){
	# First, suppress two invocations of test-lock
	# which on some machines can loop forever
	sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
	sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

	./configure --prefix=/usr	\
		--disable-static		\
		--docdir=/usr/share/doc/gettext-0.19.8.1	|| return
	make											|| return
	make install									|| return
	chmod -v 0755 /usr/lib/preloadable_libintl.so	|| return
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

exit $status
