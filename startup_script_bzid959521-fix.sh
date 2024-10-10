#!/bin/bash
# Filename: /config/startup_script_bzid959521-fix.sh
# This script performs the workaround for: bzid 959521
# See details here: https://my.f5.com/manage/s/article/K10066825

# Wait for BIG-IP to be ready (online)
source /usr/lib/bigstart/bigip-ready-functions
wait_bigip_ready

# Execute workaround commands
tmsh modify net routing bgp bgp_rd0 enabled false
tmsh modify net routing bgp bgp_rd0 enabled true
