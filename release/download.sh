#!/bin/sh
. release/versions.sh

mkdir -p .thirdparty
cd .thirdparty

# Downloads
if [ ! -f yara-${yara_version}.tar.gz ]; then
    wget -N https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/yara-project/yara-${yara_version}.tar.gz
fi

if [ ! -f GeoIP-${geoip_version}.tar.gz ]; then
    wget -N http://www.maxmind.com/download/geoip/api/c/GeoIP-${geoip_version}.tar.gz
fi

if [ ! -f libpcap-${pcap_version}.tar.gz ]; then
    wget -N http://www.tcpdump.org/release/libpcap-${pcap_version}.tar.gz
fi

if [ ! -f curl-${curl_version}.tar.gz ]; then
    wget --no-check-certificate -N http://curl.haxx.se/download/curl-${curl_version}.tar.gz
fi

if [ ! -f glib-${glib2_version}.tar.xz ]; then
    wget -N http://ftp.gnome.org/pub/gnome/sources/glib/${glib2_dir}/glib-${glib2_version}.tar.xz
fi

if [ ! -f daq-${daq_version}.tar.gz ]; then
    wget -N https://www.snort.org/downloads/snort/daq-${daq_version}.tar.gz
fi

if [ ! -f lua-${lua_version}.tar.gz ]; then
    wget --no-check-certificate -N https://www.lua.org/ftp/lua-${lua_version}.tar.gz
fi

if [ ! -f node-v${node_version}-linux-x64.tar.xz ]; then
    wget -N https://nodejs.org/download/release/v${node_version}/node-v${node_version}-linux-x64.tar.xz
fi

exit 0
