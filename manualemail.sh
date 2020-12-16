#!/bin/bash
array=( "$@" )
arraylength=$#
i=0
while [ $i -le `expr $arraylength - 1` ]
do
`terraform output -json  password | jq -r  --arg k $i '.value | .[$k | tonumber]' | base64 --decode | keybase pgp decrypt > initialpassword.txt`
`echo "" >>initialpassword.txt`
`echo "user-name : " | tee -a initialpassword.txt | terraform output -json  user-name | jq -r  --arg k $i '.value | .[$k | tonumber]'  >> initialpassword.tx$
`terraform output -json  secret | jq -r  --arg k $i '.value | .[$k | tonumber]' | base64 --decode | keybase pgp decrypt > secretkey.txt`
`echo "in this mail you find your initial password and secret key" | mail -s "FINAL AWS IAM" "${array[$i]}" -A "initialpassword.txt" -A "secretkey.txt" `

i=`expr $i + 1`
done

