#!/bin/bash
#
# USAGE:
# ./color_convert.sh colormodelayer1,colormodelayer2 input_layer1.pdf,input_layer2.pdf output.pdf
# spot colour colormode should look like "spot-COLOR NAME-0 0.64 0.67 0.02"
# where COLOR NAME is the name of the colour and 0 0.64 0.67 0.02 are cmyk values from 0 to 1



DEBUG=0
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function graytospot {
    [ $DEBUG -eq 1 ] && echo "converting : $1 to $2 \n" 
    
    ####################################################################
    #part1: let's put our custom color reference in gray_to_spot.ps
    IFS='-' read -a args <<< "$2"
    IFS=' ' read -a color <<< "${args[2]}"
    unset IFS
    #args[1] = color name, args[2] = cmyk equivalent in 1 line
    #color[0] = C, color[1] = M, color[2] = Y, color[3] = K
    spotcolor="\/spotcolor [\/Separation (${args[1]}) \/DeviceCMYK{dup ${color[0]} mul exch dup ${color[1]} mul exch dup ${color[2]} mul exch ${color[3]} mul}] def"
    [ $DEBUG -eq 1 ] && echo "spotcolor : $spotcolor \n" 
    sed -i "s/^\/spotcolor.*$/$spotcolor/g" $DIR/gray_to_spot.ps
    #endpart1
    
    ######################################################################
    #part2: convert to ps file using pdftops
    pdftops "$1"
    psfile="${1/.pdf/.ps}"
    
    ######################################################################
    #part3: modify bitmap decode from [0 1] to [1 0] in generated ps
    sed -i -e 's/Decode \[0 1\]/Decode [1 0]/g' "$psfile"
    
    ######################################################################
    #part4: convert back to pdf using gray_to_spot.ps
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" $DIR/gray_to_spot.ps "$psfile"
    
    ######################################################################
    #part5: remove ps file
    [ $DEBUG -eq 0 ] && rm "$psfile"
    
}




IFS=',' read -a layers <<< "$1"
IFS=',' read -a input_files <<< "$2"
unset IFS

if [ $DEBUG -eq 1 ]; then echo "layers : \n"; printf '%s\n' "${layers[@]}"; fi
if [ $DEBUG -eq 1 ]; then echo "files : \n"; printf '%s\n' "${input_files[@]}"; fi


#loop on files and convert them according to layers colormodes
for index in "${!layers[@]}"
do
    echo "${input_files[index]} ${layers[index]}"
    
    if [ "${layers[index]}" = "black"  ] || [[ "${layers[index]}" == spot*  ]]; then
        gs \
        -dNOPAUSE \
        -dBATCH \
        -sDEVICE=pdfwrite \
        -sProcessColorModel=DeviceGray \
        -sColorConversionStrategy=Gray \
        -sDefaultCMYKProfile=ps_cmyk.icc \
        -dOverrideICC \
        -sOutputFile="${input_files[index]/.pdf/-tmp.pdf}" "${input_files[index]}"
        if [[ "${layers[index]}" == spot*  ]]; then
            graytospot "${input_files[index]/.pdf/-tmp.pdf}" "${layers[index]}"
        fi
    elif [ "${layers[index]}" = "cmyk" ]; then
        gs \
        -dNOPAUSE \
        -dBATCH \
        -sDEVICE=pdfwrite \
        -dProcessColorModel=/DeviceCMYK \
        -sColorConversionStrategy=CMYK \
        -sDefaultCMYKProfile=ps_cmyk.icc \
        -dOverrideICC \
        -sOutputFile="${input_files[index]/.pdf/-tmp.pdf}" "${input_files[index]}"
    fi
    
    if [ $DEBUG -eq 0 ]; then
        rm "${input_files[index]}"
    fi
    
    
    
done

####IF SINGLE LAYER
if [ ${#layers[@]} = 1 ]; then
    mv "${input_files[0]/.pdf/-tmp.pdf}" "$3"
    exit
fi



####ELSE OVERLAY
inputFile="${input_files[0]/.pdf/-tmp.pdf}"
for(( i=1; i < ${#layers[@]}; i++ ))
do
    pdftk "$inputFile" multistamp "${input_files[i]/.pdf/-tmp.pdf}" output "${3/.pdf/$i.pdf}"
    if [ $DEBUG -eq 0 ]; then
        rm "$inputFile"
        rm "${input_files[i]/.pdf/-tmp.pdf}"
    fi
    
    
    inputFile="${3/.pdf/$i.pdf}"
    
done
lastFileN=$(expr ${#layers[@]} - 1)

mv "${3/.pdf/$lastFileN.pdf}" "$3"
echo "done"
exit 