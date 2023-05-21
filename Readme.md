Simple script to update cloudlfare DNS record using current public IP of your device. 
Using this script with periodic update via cron can achive Dynamic DNS configuration for your domain

Step to use this script

1. Create dns A record in Clouflare admin panel for example 
    - dyn-dns.example.com 145.244.222.44  
2. Create API token for your DNS zone, using global API key is not recomended 
    - Go to https://dash.cloudflare.com/profile/api-tokens
    - Create Token -> Create Custom token
    - Provide your custom token with clear and descriptive name for examle "dyn-dns.example.com readonly"
    - Grant Token using this config
        - Zone - DNS - Edit
        - Include - Specific Zone - example.com
    - Record given token by cloudflare for example `gk59sdj3114135ij5311`
3. Create '.env' file 

```
zone=example.com

# Record that we will be updating
record=dyn-dns.example.com

# Cloudflare authentication details
cfauthkey=gk59sdj3114135ij5311
```

4. Run the script and check if the record is updated with current public IP of your device.