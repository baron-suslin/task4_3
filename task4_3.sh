#!/bin/bash
ARGS=2

bdir="/tmp/backups/"
if ! [[ -d "${bdir}" ]];
  then
  mkdir "${bdir}"
fi

if [ "$#" -ne 2 ];
  then
  echo "Error1: wrong number of parameters sent" >&2;
  exit 1 
fi

if ! [[ -d $1 ]];
  then
  echo "Error2:  $1 - There is no such directory" >&2
  exit 2
fi

nn='^[0-9]+$'
if ! [[ $2 =~ $nn ]];
  then
  echo "Error3: $2 not a number" >&2
  exit 3
fi

fdir="${1}"
name=$(echo "${1}" | sed -r 's/[/]+/-/g' | sed 's/^-//')
fname=${name}-$(date '+%Y-%m-%d-%H%M%S').tar.gz

tar --create --gzip  -P --file="$bdir$fname" "${fdir}"

find "$bdir" -name "${name}*" -type f -printf "${bdir}%P\n" | sort -n | head -n  -"$2" | sed "s/.*/\"&\"/" | xargs rm -f

exit 0
