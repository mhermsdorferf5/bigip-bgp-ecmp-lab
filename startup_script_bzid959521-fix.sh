#!/bin/bash
# Filename: /config/startup_script_bzid959521-fix.sh
# This script performs the workaround for: bzid 959521
# See details here: https://my.f5.com/manage/s/article/K10066825

# Wait for BIG-IP to be ready (online)
source /usr/lib/bigstart/bigip-ready-functions
wait_bigip_ready

# Execute workaround commands
logger -p local0.notice "$0 Disabling & Reenabling bgp to workaround bzid 959521"
# Found that running this right after starutp didn't consistently work... so deploying a loop.
for i in {1..10}
do
    logger -p local0.notice "$0 Attempting to Disabling & Reenabling bgp to workaround bzid 959521 for the $i time."
    tmsh modify net routing bgp bgp_rd0 enabled false
    tmsh modify net routing bgp bgp_rd0 enabled true
    sleep 60
    if imish -e "show run" | grep -q "router bgp"; then
        logger -p local0.notice "$0 Routing Config loaded after $i times."
        break
    fi
done
logger -p local0.err "$0 ERROR: FAILED to load dynamic routing config after 10 times!"