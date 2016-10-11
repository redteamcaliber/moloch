#!/bin/sh
. /tmp/versions.sh

cd /tmp
builddir=`pwd`

# yara
tar zxf yara-${yara_version}.tar.gz
(cd yara-${yara_version}; ./configure --enable-static; make)

# GeoIP
tar zxf GeoIP-${geoip_version}.tar.gz
(cd GeoIP-${geoip_version} ; ./configure --enable-static; make)

# libpcap
tar zxf libpcap-${pcap_version}.tar.gz
(cd libpcap-${pcap_version}; ./configure --disable-dbus --disable-usb --disable-canusb --disable-bluetooth; make)

# daq
tar zxf daq-${daq_version}.tar.gz
(cd daq-${daq_version}; ./configure --with-libpcap-includes=${builddir}/libpcap-${pcap_version}/ --with-libpcap-libraries=${builddir}libpcap-{pcap_version}; make; make install)

# curl
tar zxf curl-${curl_version}.tar.gz
( cd curl-${curl_version}; ./configure --disable-ldap --disable-ldaps --without-libidn --without-librtmp; make)

# glib2
xzcat glib-${glib2_version}.tar.xz | tar xf -
(cd glib-${glib2_version} ; ./configure --disable-xattr --disable-shared --enable-static --disable-libelf --disable-selinux --with-pcre=internal; make)

# lua
tar zxf lua-${lua_version}.tar.gz
(cd lua-${lua_version}; make MYCFLAGS=-fPIC linux)

exit 0
