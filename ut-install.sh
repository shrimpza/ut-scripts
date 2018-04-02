#!/bin/bash
#
# UT99 and UT2004 zip-distributed map/mod installer
#
# Extracts the contents of a .zip file, often containing a loose
# unstructured collection of files, which the user is generally
# expected to know which file types go into which directories,
# into an appropriate directory structure.
#
# Usage:
#  ut-install.sh <zip-file> <extract-path>

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

    ["ut2"]="Maps"
    ["ogg"]="Music"
    ["ucl"]="System"
    ["upl"]="System"
    ["usx"]="StaticMeshes"
    ["ukx"]="Animations"
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
