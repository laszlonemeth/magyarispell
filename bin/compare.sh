#!/bin/bash
#
# compare 
# 
# line diff disregarding duplicates
# dump lines found in file1 but NOT found in file2

if [ "$1" = "" ]; then
	echo "usage: $0 file1 file2"
	exit 1
fi

if [ "$2" = "" ]; then
	echo "usage: $0 file1 file2"
	exit 1
fi

comm -23 <(sort $1|uniq) <(sort $2|uniq)

exit 0