#!/bin/bash

NumberOfTests=$1
URL=$2
SleepDuration=$3

#Check Vars
if [[ -z $1 ]] ; then NumberOfTests="10" ; fi
if [[ -z $2 ]] ; then URL="www.google.com" ; fi
if [[ -z $3 ]] ; then SleepDuration="0.250" ; fi


echo -e "\e[34mTesting URL \"$URL\" $NumberOfTests times every $SleepDuration s\033[m"

#Init Var
count=0
TotalResult=0
AverageResult=0
MinResult=10000
MaxResult=0

while [ $count -lt $NumberOfTests ] ; do

  #time_namelookup is the time the conversion 'name to ip' takes. many different options are possible for curl
  ReturnvalueIsS=$(curl --output /dev/null --silent --write-out '%{time_namelookup}' $URL)
  #Convert S to MS
  Returnvalue=$(awk "BEGIN {print $ReturnvalueIsS*1000}")

  echo -ne "Current response time : $Returnvalue ms              "\\r

  TotalResult=$(awk "BEGIN {print ($TotalResult + $Returnvalue)}")
  MinResult=$(echo $Returnvalue $MinResult | awk '{if ($1 < $2) print $1; else print $2}')
  MaxResult=$(echo $Returnvalue $MaxResult | awk '{if ($1 > $2) print $1; else print $2}')

  sleep $SleepDuration
  ((count=count+1))
done

AverageResult=$(awk "BEGIN {print $TotalResult / $count}")
echo "AverageResult = $AverageResult ms | Min value = $MinResult ms | Max value = $MaxResult ms"

exit 0