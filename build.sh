#!/bin/bash
OPTIND=1
pdflatex -halt-on-error golang-ref-sheet.tex
if [ $? -ne 0 ]; then
    echo "Build failed. Check output of golang-ref-sheet.log" >&2
    exit 1
fi
rm -f golang-ref-sheet.aux
rm -f golang-ref-sheet.log
rm -f figures/*converted-to.pdf
GEN_PNG=
while getopts ":gp:" opt; do
    case "$opt" in
        g)
            GEN_PNG=1
            ;;
        p)
            $OPTARG golang-ref-sheet.pdf
            ;;
        :)
            echo "-$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ ! -z "$GEN_PNG" ]; then
    if type -P convert 2>/dev/null; then
        convert -density 200 -background white -alpha remove -crop 500x300+50+50 golang-ref-sheet.pdf[0] github/preview1.png
    else
        echo "Please install imagemagick to generate previews" >&2
    fi
fi
