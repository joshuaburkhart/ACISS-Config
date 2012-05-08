#!/bin/bash

TMP_FILE_1=$(date +%s | shasum | tr ' -' 'X')
touch $TMP_FILE_1
sleep 1
TMP_FILE_2=$(date +%s | shasum | tr ' -' 'X')
touch $TMP_FILE_2

echo "Current Jobs:"
qstat -n | grep jburkhar | awk '{$10=""; $11=""; print $0}' > $TMP_FILE_1
cat $TMP_FILE_1
cat $TMP_FILE_1 > $TMP_FILE_2

echo ""
echo "Activity:"

while true
do

  qstat -n | grep jburkhar | awk '{$11=""; print $0}' > $TMP_FILE_1
  diff $TMP_FILE_1 $TMP_FILE_2
  cat $TMP_FILE_1 > $TMP_FILE_2
  sleep 5

done

echo "Exiting..."
rm $TMP_FILE_1
rm $TMP_FILE2
