#!/bin/sh
yara_version=1.7
geoip_version=1.6.0
pcap_version=1.7.4
curl_version=7.50.2
glib2_dir=2.48
glib2_version=2.48.2
node_version=0.10.46
daq_version=2.0.6

export PATH=/data/moloch/bin:$PATH
cd /tmp/moloch
./configure --with-libpcap=../libpcap-${pcap_version} --with-yara=../yara-${yara_version} --with-GeoIP=../GeoIP-${geoip_version} --with-curl=../curl-${curl_version} --with-glib2=../glib-${glib2_version}
make clean
make
make install

# Copy files
cp -f config.ini /data/moloch/etc/config.ini.sample
cp -f release/README.txt /data/moloch/
cp -f release/*upstart.conf /data/moloch/etc
cp -f release/*.demo.yml /data/moloch/etc
cp -f release/moloch_update_geo.sh release/moloch_add_user.sh release/Configure /data/moloch/bin
