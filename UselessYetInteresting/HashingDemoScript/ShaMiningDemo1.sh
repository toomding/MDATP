#!/bin/bash
NounceCounter=0
echo "Begin from 1 to 10 times hash try in first batch"
while true
do
    NounceCounter=$(($NounceCounter+1))
    ThisShaValue=$(echo "This is N-1 Block all Content + $NounceCounter" | shasum -a 1 | cut -d ' ' -f1)
    sleep 3
    echo "The $NounceCounter try, hash result is $ThisShaValue"
    if [[ $ThisShaValue == *"1987"* ]];then echo "Found it! it is $ThisShaValue";break;else echo "Not Found Continuing." ;fi
    if [[ $NounceCounter -eq 10 ]];then break;fi
done
