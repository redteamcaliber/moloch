#!/bin/sh
yara_version=1.7
geoip_version=1.6.0
pcap_version=1.7.4
curl_version=7.50.3
glib2_dir=2.48
glib2_version=2.48.2
node_version=0.10.46
daq_version=2.0.6
lua_version=5.3.3

export PATH=/data/$NAME/bin:$PATH
cd /tmp/$NAME
./configure --with-libpcap=../libpcap-${pcap_version} --with-yara=../yara-${yara_version} --with-GeoIP=../GeoIP-${geoip_version} --with-curl=../curl-${curl_version} --with-glib2=../glib-${glib2_version} --with-lua=../lua-${lua_version}
make clean
make
(cd capture/plugins/lua ; make)
(cd capture/plugins/pfring ; make)
make install

# Copy files
cp -f config.ini /data/$NAME/etc/config.ini.sample
cp -f release/README.txt /data/$NAME/
cp -f release/*upstart.conf /data/$NAME/etc
cp -f release/*.demo.yml /data/$NAME/etc
cp -f release/moloch_update_geo.sh release/moloch_add_user.sh release/Configure /data/$NAME/bin
