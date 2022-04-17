#! /usr/bin/env bash
#
# USAGE
# ./colorSepatation.sh input.pdf
#
# OUTPUT
# a directory called `tiffsep` where you have a jpg image per color channel per page

rm -r pages 2> /dev/null 

bn=$(basename ${1} .pdf)

# Change resolution here, -r150x150 = 150dpi
gs -dSimulateOverprint=true -sDEVICE=tiffsep -dNOPAUSE -dBATCH -r150x150 -sOutputFile=${bn}-page%03d.tif ${1}

echo "MOVE TIF FILES INTO '${bn}-plates' FOLDER"
mkdir -p ${bn}_plates
mv ${bn}*.tif ${bn}_plates
cd ${bn}_plates

echo "CONVERT TIF TO JPG"
for TIF in *.tif; do convert $TIF $(basename $TIF .tif).jpg; done

echo "REMOVE TIF FILES"
rm *tif

echo "MAKE COLOURED PREVIEW"
for Cyan in *Cyan*; do magick $Cyan -colorspace Gray +level-colors cyan, $Cyan; done
for Magenta in *Magenta*; do magick $Magenta -colorspace Gray +level-colors magenta, $Magenta; done
for Yellow in *Yellow*; do magick $Yellow -colorspace Gray +level-colors yellow, $Yellow; done



echo "GENERATE HTML PREVIEW PAGE"
cat ../colorSeparation_header.html > 00-${bn}-plates.html

start=1
end=$(( $(ls | wc -l) /5))

size=$(identify ${bn}-page001.jpg |  cut  -d " " -f 3)
width=$(echo ${size} | cut -d "x" -f 1)
height=$(echo ${size} | cut -d "x" -f 2)

for i in $(eval echo "{$start..$end}")
do
    page=$(printf "%03u" ${i})
    echo "<div id='page${page}' class='page' style='height: ${height}px; width: ${width}px;'>" >> 00-${bn}-plates.html
    echo "    <img class='all' style='height: ${height}px; width: ${width}px;' src='${bn}-page${page}.jpg' />" >> 00-${bn}-plates.html
    echo "    <img class='cyan' style='height: ${height}px; width: ${width}px;' src='${bn}-page${page}(Cyan).jpg' />" >> 00-${bn}-plates.html
    echo "    <img class='magenta' style='height: ${height}px; width: ${width}px;' src='${bn}-page${page}(Magenta).jpg' />" >> 00-${bn}-plates.html
    echo "    <img class='yellow' style='height: ${height}px; width: ${width}px;' src='${bn}-page${page}(Yellow).jpg' />" >> 00-${bn}-plates.html
    echo "    <img class='black' style='height: ${height}px; width: ${width}px;' src='${bn}-page${page}(Black).jpg' />" >> 00-${bn}-plates.html
    echo "</div>" >> 00-${bn}-plates.html
done

cat ../colorSeparation_footer.html  >> 00-${bn}-plates.html
