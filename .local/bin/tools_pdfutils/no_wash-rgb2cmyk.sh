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
op=$2

pdftops ${bn}.pdf

gs \
-dSAFER \
-dNOPAUSE \
-dBATCH \
-sDEVICE=pdfwrite \
-dProcessColorModel=/DeviceCMYK \
-sColorConversionStrategy=CMYK \
-sOutputFile=${bn}-cmyk.pdf ./forceblack.ps ${bn}.ps

if [[ $op == "overprint" ]]
    then
        pdftops -level2sep ${bn}-cmyk.pdf
        sed -e "s/false \(op\)/true \1/gI" ${bn}-cmyk.ps > ${bn}-cmyk-op.ps
        gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=${bn}-cmyk-op.pdf ./forceblack.ps ${bn}-cmyk-op.ps
        rm ${bn}-cmyk.pdf
        rm ${bn}-cmyk.ps
fi        

rm ${bn}.ps


