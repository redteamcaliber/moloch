#!/bin/sh
yara_version=1.7
geoip_version=1.6.0
pcap_version=1.7.4
curl_version=7.50.3
glib2_dir=2.48
glib2_version=2.48.2
node_version=4.6.0
daq_version=2.0.6
lua_version=5.3.3

cd /tmp
builddir=`pwd`
echo "BUILDIR=$builddir"

# Downloads
wget -N https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/yara-project/yara-${yara_version}.tar.gz
wget -N http://www.maxmind.com/download/geoip/api/c/GeoIP-${geoip_version}.tar.gz
wget -N http://www.tcpdump.org/release/libpcap-${pcap_version}.tar.gz
wget -N http://curl.haxx.se/download/curl-${curl_version}.tar.gz
wget -N http://ftp.gnome.org/pub/gnome/sources/glib/${glib2_dir}/glib-${glib2_version}.tar.xz
wget -N https://nodejs.org/download/release/v${node_version}/node-v${node_version}-linux-x64.tar.xz
wget -N https://www.snort.org/downloads/snort/daq-${daq_version}.tar.gz
wget -N https://www.lua.org/ftp/lua-${lua_version}.tar.gz

# dir setup
mkdir /data /data/moloch /data/moloch/etc /data/moloch/bin /data/moloch/logs /data/moloch/raw 
chown nobody /data/moloch /data/moloch/etc /data/moloch/bin /data/moloch/logs /data/moloch/raw
chmod og-rwx /data/moloch/raw

# node
(cd /data/moloch ; xzcat /tmp/node-v${node_version}-linux-x64.tar.xz | tar xf -)
ln -sf /data/moloch/node-v${node_version}-linux-x64/bin/n* /data/moloch/bin

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
