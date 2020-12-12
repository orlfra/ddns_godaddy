#!/bin/bash

# It is a simple script that works fine
# is up to you to set up your credentials correctly


# your data here
DOMAIN=example.com
API_KEY=xxxxxxxxxx
API_SECRET=xxxxxxx

# Tested with Production api 

TTL=600
TYPE=A
NAME=@

# Get ip associated with dns and host ip address
# short and dirty as I like it :) 
DOMAIN_IP=$( dig +short $DOMAIN )
HOST_IP=$( curl -s http://api.ipify.org )


echo Domain IP for $DOMAIN: $DOMAIN_IP
echo Host IP: $HOST_IP


# Thanks @CarlEdman for the curl command and saving me
# time from figuring out what was wrong with other scripts
# Actually the "new" godaddy apis expected a json array [wrapped]
[ $DOMAIN_IP != $HOST_IP ] && 
    curl -X PUT -H"Authorization: sso-key ${API_KEY}:${API_SECRET}" \
    -H"Content-type: application/json"  \
    "https://api.godaddy.com/v1/domains/${DOMAIN}/records/${TYPE}/${NAME}" \
    -d"[{\"data\":\"${HOST_IP}\",\"ttl\":${TTL}}]" && echo "Updated (well maybe)" && exit 


echo "No need to update..."
