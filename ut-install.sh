#!/bin/bash

ZF=$1
OP=$2

declare -A TYPES=(
    ["unr"]="Maps"
    ["utx"]="Textures"
    ["u"]="System"
    ["int"]="System"
    ["ini"]="System"
    ["umx"]="Music"
    ["uax"]="Sounds"
)

declare -a IGNORE=(
    "Manifest.int"
    "Manifest.ini"
)

TYPELIST=""; for i in "${!TYPES[@]}" ; do TYPELIST="$TYPELIST|$i"; done
TYPELIST=${TYPELIST:1}

for i in `zipinfo -1 $ZF`; do
    FILE=$(basename $i)
    EXT="${FILE##*.}"

    for f in "${IGNORE[@]}"; do
        [[ $f == $FILE ]] && continue 2
    done

    if [[ "$EXT" =~ ^($TYPELIST)$ ]]; then
        TYPE=${TYPES[$EXT]}
        mkdir -p "$OP/$TYPE" # create outputh path if needed
        F=$(printf %q $i) # escape special characters in file path

        echo "$TYPE: $F"

        unzip -qjn "$ZF" "$F" -d "$OP/$TYPE"
    fi
done

