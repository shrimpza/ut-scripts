#!/bin/bash

# scratch file for exporting map textures from UT2004 maps
# using UCC.exe via wine, to find map preview screenshots

# export map images in bmp and dds formats, batch file
#for %%F in (Maps/*.ut2) do (
#    echo %%F
#    if not exist temp_img\%%~nF mkdir temp_img\%%~nF
#    System\ucc batchexport %%F Texture dds ..\temp_img\%%~nF
#    System\ucc batchexport %%F Texture bmp ..\temp_img\%%~nF
#)


# execute batch export with wine, from UT2004 dir
# env WINEPREFIX=/home/shrimp/.wine/ut2004 /opt/wine-devel/bin/wine cmd /c sshot.bat

SHOT=".+?[sS]hot.+?";

mkdir -p mapimages

for IMG in ./temp_img/*/*.bmp ./temp_img/*/*.dds; do

    if [[ ! -s $IMG ]]; then
        continue
    fi

    EXT="${IMG##*.}"
    DIR=$(basename $(dirname $IMG));
    OUT="./mapimages/$DIR.png"

    if [[ -e $OUT ]]; then
        continue
    fi

    if [[ $IMG =~ $SHOT ]]; then
        echo $IMG
        #convert $IMG $OUT
        gimp -i -b "(dds2png \"${IMG}\" \"${OUT}\")" -b "(gimp-quit 0)"
    fi
done

# also optionally convert all to lowercase .jpg files:
# for i in *.png; do o="${i%.*}.jpg"; convert $i ${o,,}; done;
