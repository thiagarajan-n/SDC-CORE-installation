#!/usr/bin/env bash

curl -o /tmp/sdc.tgz -L ${FULLTARBALL_URL}

# for f in /tmp/*.tgz; do
#         [ -e "$f" ] && mv "$f" /core-datacollctor/sdc.tgz || curl -o /tmp/sdc.tgz -L "${SDC_URL}"
#         break
# done

tar xzf /tmp/sdc.tgz -C /opt/local/

echo 'Done unzipping'
ls /opt/local
echo 'list unzipping'

# cp /opt/local/streamsets-datacollector-3.6.1/systemd/sdc.service /etc/systemd/system/sdc.service
# cp /opt/local/streamsets-datacollector-3.6.1/systemd/sdc.socket /etc/systemd/system/sdc.socket

# cp -R /opt/local/streamsets-datacollector-3.6.1/etc/* /etc/sdc

cp /opt/local/streamsets-datacollector-3.6.0/systemd/sdc.service /etc/systemd/system/sdc.service
cp /opt/local/streamsets-datacollector-3.6.0/systemd/sdc.socket /etc/systemd/system/sdc.socket

cp -R /opt/local/streamsets-datacollector-3.6.0/etc/* /etc/sdc
ls /etc/sdc

