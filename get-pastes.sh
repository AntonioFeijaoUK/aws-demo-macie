#!/bin/bash

##
##
## MIT - use at your own responsability
##
## started by AntonioCloud.com - 2020
##


cd /home/ec2-user/pastebin

DATE=$(date +%Y-%m-%d)
HOUR=$(date +%H)
NOW=$(date +%Y-%m-%d-%H%M-%S)

echo "Date: ${DATE}"
echo "Hour: ${HOUR}"
echo "Now:   ${NOW}"


DIR="s3-pastebin-macie-demo/${DATE}/${HOUR}/"

[ -d "${DIR}" ] &&  echo "Found directory ${DIR}." || (echo "Directory ${DIR} NOT found, creating it..." ; mkdir -p ${DIR} )




LAST100=$(curl https://scrape.pastebin.com/api_scraping.php?limit=100)

echo "********** Date and Time NOW : ${NOW} ************** " >> LAST100.log
echo ${LAST100} | jq .                   >> LAST100.log


LINKS=$(echo ${LAST100} | jq '.[].scrape_url' | sed s/'"'//g)
echo "Got the links: ${LINKS}"


for LINK in $LINKS; do FILENAME=$(echo ${LINK} | cut -f 2 -d '='| sed s/'"'/''/g ) ; curl ${LINK} --output ./${DIR}/${FILENAME} ; done


