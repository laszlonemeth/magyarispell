#!/usr/bin/env bash
# A szotar k�nyvt�rban �llva kigy�jti a sz�t�r szavait
export LC_ALL=C
cd ../szotar
cat `find -type f -name '*.[0-9]'` | m4 | grep -v TILTOTT | grep -v '/.*w' |
awk '{print$1}'  | grep -v '^#' | sed 's#/.*##' | sort | uniq
