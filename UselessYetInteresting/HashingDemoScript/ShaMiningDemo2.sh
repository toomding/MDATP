#!/bin/bash
NounceCounter=10
echo "Begin from 11 to 20 times hash try in second batch"
while true
do
    NounceCounter=$(($NounceCounter+1))
    ThisShaValue=$(echo "This is N-1 Block all Content + $NounceCounter" | shasum -a 1 | cut -d ' ' -f1)
    echo "The $NounceCounter try, hash result is $ThisShaValue"
    if [[ $ThisShaValue == *"1987"* ]];then echo "Found it! it is $ThisShaValue";break;else echo "Not Found Continuing." ;fi
    if [[ $NounceCounter -eq 20 ]];then break;fi
    sleep 3
done
