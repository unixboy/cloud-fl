#!/bin/sh
# modified by jfro from http://www.cnysupport.com/index.php/linode-dynamic-dns-ddns-update-script
# Update: changed because the old IP-service wasn't working anymore
# Uses curl to be compatible with machines that don't have wget by default
# modified by Ross Hosman for use with cloudflare.
#
# Place at:
# /usr/local/bin/cf-ddns.sh
# if you're lazy (like me): curl https://gist.githubusercontent.com/larrybolt/6295160/raw/9efbc7850613e06db1b415bdf4fbdd8361209865/cf-ddns.sh > /usr/local/bin/cf-ddns.sh && chmod +x /usr/local/bin/cf-ddns.sh && vim /usr/local/bin/cf-ddns.sh
# run `crontab -e` and add next line:
# 0 */5 * * * * /usr/local/bin/cf-ddns.sh >/dev/null 2>&1
 
cfkey=API-key
cfuser=username(email)
cfhost=host-you-want-to-change
 
WAN_IP=`curl -s http://icanhazip.com`
if [ -f $HOME/.wan_ip-cf.txt ]; then
        OLD_WAN_IP=`cat $HOME/.wan_ip-cf.txt`
else
        echo "No file, need IP"
        OLD_WAN_IP=""
fi
 
if [ "$WAN_IP" = "$OLD_WAN_IP" ]; then
        echo "IP Unchanged"
else
        echo $WAN_IP > $HOME/.wan_ip-cf.txt
        echo "Updating DNS to $WAN_IP"
  curl -s https://www.cloudflare.com/api.html?a=DIUP\&hosts="$cfhost"\&u="$cfuser"\&tkn="$cfkey"\&ip="$WAN_IP" > /dev/null
fi
