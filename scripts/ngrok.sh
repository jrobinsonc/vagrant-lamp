#!/usr/bin/env bash

# Download ngrok (http://ngrok.com) and make it available

TOKEN=$1

apt-get install -yqq unzip

NGROK_URL=$( curl --silent https://ngrok.com/download | grep "href" | grep linux-amd | sed -e 's/^.*href="//' -e 's/".*$//' )
wget "$NGROK_URL" -O ngrok.zip
unzip ngrok.zip
rm -f ngrok.zip
mv ngrok /usr/local/bin
chmod 755 /usr/local/bin/ngrok

if [ ! -z $TOKEN ]; then
    ngrok authtoken $TOKEN
fi