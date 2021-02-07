#!/bin/bash

# usage: /usr/local/bin/certbot renew --manual-auth-hook /etc/letsencrypt/renewal/letsencrypt_godaddy_renew_hook.sh.sh
apikey=
apisecret=
maindomain=
record=
curl -X PUT "https://api.godaddy.com/v1/domains/${maindomain}/records/TXT" \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: sso-key $apikey:$apisecret" \
    --data '[{"type": "TXT","name": "'$record'","data": "'${CERTBOT_VALIDATION}'","ttl": 600}]'
sleep 30