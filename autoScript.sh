#!/bin/bash

#this is automatic steps to perform made with all commands that i get to know and other sources

read -p "Did you add url? (y/n): " answer
if [ "$answer" != "y" ]; then
    echo "Exiting... Nano and change url"
    exit 0
fi

#Finding subdomains
curl -s https://crt.sh/\?q\=\academiaerp.com\&output=json | jq -r '.[].name_value' | grep -Po '(\w+(\.\w+)+)$' | anew subdomains.txt

#Finding live subdomains
cat subdomains.txt | httpx-toolkit -l subdomains.txt -ports 443,80,8080,8888,8000 -threads 200 > subdomains_alive.txt

#Nmap by naabu RESULTS
naabu -list subdomains.txt -c 50 -nmap-cli 'nmap -sV -sC' -o naabu_NmapResults.txt

#Finding parameters using gau tool
cat subdomains_alive.txt | gau > params.txt

#Filtering Params
cat params.txt | uro -o filterparam.txt

#Grep .js files to find keys
cat filterparam.txt | grep ".js$" > jsfiles.txt
cat jsfiles.txt| uro | anew jsfiles.txt

#using Secret Finder to find keys
cat jsfiles.txt | while read url; do python3 /home/unbreakable/bbStuff/SecretFinder/SecretFinder.py -i $url -o cli >> secret.txt; done

#showing secret.txt files
cat secret.txt
