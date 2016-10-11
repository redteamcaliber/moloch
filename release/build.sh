#!/bin/sh
. /tmp/$NAME/release/versions.sh

# dir setup
mkdir /data /data/$NAME /data/$NAME/etc /data/$NAME/bin /data/$NAME/logs /data/$NAME/raw 
chown nobody /data/$NAME /data/$NAME/etc /data/$NAME/bin /data/$NAME/logs /data/$NAME/raw
chmod og-rwx /data/$NAME/raw

# node
(cd /tmp ; wget -N https://nodejs.org/download/release/v${node_version}/node-v${node_version}-linux-x64.tar.xz)
(cd /data/$NAME ; xzcat /tmp/node-v${node_version}-linux-x64.tar.xz | tar xf -)
ln -sf /data/$NAME/node-v${node_version}-linux-x64/bin/npm /data/$NAME/bin
ln -sf /data/$NAME/node-v${node_version}-linux-x64/bin/node /data/$NAME/bin

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
