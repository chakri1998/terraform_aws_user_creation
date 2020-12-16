#!/bin/bash

array=( "$@" )
arraylength=$#
i=0
while [ $i -le `expr $arraylength - 1` ]
do

`jq -r --arg k $i '.[$k | tonumber]' secret | base64 --decode | keybase pgp decrypt > secretkey.txt`
`jq -r --arg k $i '.[$k | tonumber]' password | base64 --decode | keybase pgp decrypt > initialpassword.txt`
`jq -r --arg k $i '.[$k | tonumber]' username > username.txt`
`echo "in this mail you find your initial password and secret key" | mail -s "FINAL AWS IAM" "${array[$i]}" -A "initialpassword.txt" -A "secretkey.txt" -A "username.txt" `

i=`expr $i + 1`
done
