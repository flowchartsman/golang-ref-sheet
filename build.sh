#!/bin/bash
OPTIND=1

export BUILD_DIR=${BUILD_DIR-${TMPDIR}}

generate_preview () {
    convert -density 200 -background white -alpha remove golang-ref-sheet.pdf[0] -crop 500x300+$1+$2 \( +clone -background black -shadow 80x3+4+4 \) +swap -background white -layers merge +repage github/$3
}

lualatex --shell-escape --output-directory=$BUILD_DIR -halt-on-error golang-ref-sheet.tex
if [ $? -ne 0 ]; then
    echo "Build failed. Check output of $BUILD_DIR/golang-ref-sheet.log" >&2
    exit 1
fi
cp $BUILD_DIR/golang-ref-sheet.pdf .
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
        generate_preview 50 50 preview1.png
    else
        echo "Please install imagemagick to generate previews" >&2
    fi
fi
