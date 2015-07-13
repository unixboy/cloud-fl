#!/bin/sh
# modified by jfro from http://www.cnysupport.com/index.php/linode-dynamic-dns-ddns-update-script
# Update: changed because the old IP-service wasn't working anymore
# Uses curl to be compatible with machines that don't have wget by default
# modified by Ross Hosman for use with cloudflare.
#
# Place at:
# /usr/local/bin/cf-ddns.sh
# run `crontab -e` and add next line:
# 0 */5 * * * * /usr/local/bin/cf-ddns.sh >/dev/null 2>&1

cfkey=FILL_W-ITH_YOUR_API_KEY
cfuser=FILL_W-ITH_YOUR_EMAIL
cfhost=FILL_W-ITH_YOUR_HOST_ZONE
cfid=FILL_W-ITH_YOUR_ID (get this on cloudflare api documentation)
domain=FILL_W-ITH_YOUR_DOMAIN

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
         curl https://www.cloudflare.com/api_json.html \
          -d a=rec_edit \
          -d tkn=$cfkey \
          -d email=$cfuser \
          -d z=$domain \
          -d id=$cfid \
          -d type=A \
          -d name=$cfhost \
          -d ttl=1 \
          -d "content=$WAN_IP" > /dev/null
fi
