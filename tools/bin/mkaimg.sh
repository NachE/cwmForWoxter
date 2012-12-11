#!/bin/bash
# Script writed by J.A. Nache
# 
#           1        2          3          4
# Usage: outfile ramdisk_dir bootimg.cfg kernel
# Sample: ./build.sh test.img ramdisk/ bootimg.cfg zImage
# This script use abootimg so you need to have this installed.
#


if [ $# -ne 4 ]; then
  echo "Usage: $0 <outfile.img> ramdisk_dir/ bootimg.cfg zImage"
  exit 2
fi



if [ -f $1 ]; then
echo "File $1 already exists, exiting..."
exit 1
fi

WDIR=$PWD
TIMESTAMP=`date +%s`

echo "***************************"
echo "Entering in ramdisk dir ..."
cd $2
if [ $? -eq 0 ]; then echo "Result: Ok"; else echo "Result: FAIL"; exit 1; fi

echo "***************************"
echo "Making compressed ramdisk ..."
find . | cpio -o -H newc | gzip > /tmp/$TIMESTAMP.ramdisk.cpio.gz
if [ $? -eq 0 ]; then echo "Result: Ok"; else echo "Result: FAIL"; exit 1; fi

echo "***************************"
cd $WDIR 
echo "Creating img file $1 ..."
abootimg --create $1 -f $3 -k $4 -r /tmp/$TIMESTAMP.ramdisk.cpio.gz
if [ $? -eq 0 ]; then echo "Result: Ok"; else echo "Result: FAIL"; exit 1; fi

echo "***************************"
echo "Removing compressed ramdisk ..."
rm /tmp/$TIMESTAMP.ramdisk.cpio.gz
if [ $? -eq 0 ]; then echo "Result: Ok"; else echo "Result: FAIL. Ignored"; fi

if [ -f $1 ]; then
echo "$1 Created."
fi


