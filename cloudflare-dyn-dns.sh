#!/bin/bash
source .env

# Get current public IP
currentIP=$(curl -s http://api.ipify.org)
resolvedIP=$(dig +short $record @1.1.1.1)

echo "Current Public IP : $currentIP ";
echo "Current Resolved IP : $resolvedIP ";

# Check if the IP has changed
if [ "$currentIP" != "$resolvedIP" ]; then

    # Get the zone id for the requested zone
    zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
        -H "Authorization: Bearer $cfauthkey" \
        -H "Content-Type: application/json" | python3 -c "import sys, json; print(json.load(sys.stdin)['result'][0]['id'])")
    
    # Get the dns record id
    recordid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?name=$record" \
        -H "Authorization: Bearer $cfauthkey" \
        -H "Content-Type: application/json" | python3 -c "import sys, json; print(json.load(sys.stdin)['result'][0]['id'])")
    
    # Update DNS record
    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$recordid" \
        -H "Authorization: Bearer $cfauthkey" \
        -H "Content-Type: application/json" \
        --data "{\"id\":\"$zoneid\",\"type\":\"A\",\"proxied\":false,\"name\":\"$record\",\"content\":\"$currentIP\"}"

    echo "Zone id : $zoneid and record id : $recordid" 
    echo "Update DNS Record from $resolvedIP to $currentIP"
    echo "DNS record updated on: $(date)"
else
    echo "IP has not changed"
fi
