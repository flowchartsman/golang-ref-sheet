#!/bin/bash
OPTIND=1
pdflatex golang-ref-sheet.tex
rm -f golang-ref-sheet.aux
rm -f golang-ref-sheet.log
rm -f figures/*converted-to.pdf
while getopts ":p:" opt; do
    case "$opt" in
        p)
            $OPTARG golang-ref-sheet.pdf
            ;;
        :)
            echo "-$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done
