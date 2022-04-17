#! /usr/bin/env bash

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-ho] [-f OUTFILE] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

Converts RGB PDF to CMYK PDF preserving true black for vectors. Overprint for
black is available as an option.

    -h          display this help and exit
    -f OUTFILE  specify the outfile
    -o          enable overprinting
EOF
}

# Initialize our own variables:
output=""
overprint=false

OPTIND=1
# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.

while getopts "hof:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        o)  overprint=true
            ;;
        f)  output=$OPTARG
            ;;
        '?')
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

# Everything that's left in "$@" is a non-option.  In our case, a FILE to process.
# printf 'verbose=<%d>\noutput_file=<%s>\nLeftovers:\n' "$overprint" "$output_file"
# printf '<%s>\n' "$@"


input="${@}"
forceblack=$(dirname $0)/forceblack.ps
ps="/tmp/$(basename $input ".pdf").ps"

if [ -z "$output" ] ; then
    output="$(dirname $input)/$(basename $input '.pdf')-cmyk.pdf"
fi

cmyk="/tmp/$(basename $input ".pdf")-cmyk.pdf"
cmykps="/tmp/$(basename $input ".pdf")-cmyk.ps"
cmykpsop="/tmp/$(basename $input ".pdf")-cmyk-op.ps"
cmykop="/tmp/$(basename $input ".pdf")-cmyk-op.pdf"


pdftops "${input}" "${ps}"

gs \
    -dNOPAUSE \
    -dBATCH \
    -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/prepress \
    -dColorImageResolution=300 \
    -dDownsampleColorImages=false \
    -dProcessColorModel=/DeviceCMYK \
    -sColorConversionStrategy=CMYK \
    -dAutoFilterColorImages=false \
    -dAutoFilterGrayImages=false \
    -dColorImageFilter=/FlateEncode \
    -dGrayImageFilter=/FlateEncode\
    -dColorConversionStrategy=/LeaveColorUnchanged \
    -dDownsampleMonoImages=false \
    -dDownsampleGrayImages=false \
    -dDownsampleColorImages=false\
    -dJPEGQ=100 \
    -dColorImageResolution=300\
    -sOutputFile="${cmyk}" "${forceblack}" "${ps}"


if [ "$overprint" = true  ] ; then
    echo "overprinting"
    pdftops -level2sep ${cmyk} ${cmykps}
    sed -e "s/false \(op\)/true \1/gI" ${cmykps} > ${cmykpsop}
    gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dColorImageResolution=300 -dDownsampleColorImages=false -sOutputFile=${output} ${forceblack} ${cmykpsop}
else
    cp ${cmyk} ${output}
fi

rm -f "${cmyk}" "${cmykps}" "${cmykpsop}" "${cmykop}"




