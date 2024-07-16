#!/bin/bash

# Check numbers of arg
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 --[convert|images] <dir>"
    exit 1
fi

case $1 in
    --convert)
        pandoc -s $2.html -o $2.org --wrap=none
        ;;
    --images)
	rm -rf $2
	mv $2-Dateien $2
	grep "file:.*\.\(png\|jpg\|jpeg\|JPG\|webp\)" $2.org | sed -e 's/\[\[//' -e 's/\]\]//' -e 's/file://' | sed ':a;N;$!ba;s/\n/ /g' | xclip
        mkdir -p build
	mv `xclip -o` build
	rm -r $2
	mv build $2
        ;;
    *)
        # something
        echo "Invalid option: $1"
        exit 1
        ;;
esac
