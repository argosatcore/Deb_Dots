#! /bin/bash

# CONVERTS RGB PDF TO CMYK PDF PRESERVING TRUE BLACK FOR VECTORS
# OVERPRINT FEATURE IS AVAILABLE WITH AN OPTION

# USAGE:
# ./rgb2cmyk.sh input.pdf
# ./rgb2cmyk.sh input.pdf overprint

# OUTPUT:
# input-cmyk.pdf
# input-cmyk-op.pdf (in case of overprint)

bn=$(basename $1 ".pdf")
op=${2:-knockout}

gs -q -sDEVICE=pdfwrite -o ${bn}-CMYK.pdf -sColorConversionStrategy=CMYK -sSourceObjectICC=iccprofile.txt $1

if [[ $op == "overprint" ]]
    then
        pdftops -level2sep ${bn}-CMYK.pdf
        sed -e "s/false \(op\)/true \1/gI" ${bn}-CMYK.ps > ${bn}-CMYK-op.ps
        #gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=${bn}-CMYK-op.pdf ./forceblack.ps ${bn}-CMYK-op.ps
        gs -q -sDEVICE=pdfwrite -o ${bn}-CMYK-op.pdf -sColorConversionStrategy=CMYK -sSourceObjectICC=control.txt ${bn}-CMYK-op.ps
        rm ${bn}-CMYK.pdf
        rm ${bn}-CMYK.ps
fi        



