#!/usr/bin/env bash
# A szotar könyvtárban állva kigyûjti a szótár szavait
export LC_ALL=C
cd ../szotar
cat `find -type f -name '*.[0-9]'` | m4 | grep -v TILTOTT | grep -v '/.*w' |
awk '{print$1}'  | grep -v '^#' | sed 's#/.*##' | sort | uniq
