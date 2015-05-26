#!/bin/bash

CONFIG_FOR="PERSONAL_CONFIG" \
personal_cluster_size=4 \
personal_slave_cpu=1 \
personal_ram=1500 \
personal_master_ip='10.20.3.2' \
personal_master_network='10.20.3.1' \
personal_external_ip='172.16.3.1' \
personal_internal_ip='172.16.4.1' \
./launch.sh
