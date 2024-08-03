#!/bin/bash

# Check numbers of arg
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 --[convert|images|makeREADME] <dir>"
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
    --makeREADME)
	sed -i 's/\(file:[^/]*\)\/\([^/]*\)/file:\2/' *.org
	for f in *.org; do
	    DIR=`basename $f .org`
	    if [ -d $DIR ]; then
		echo "✅ $DIR"
		mv $f $DIR/index.org
		cd $DIR
		ln -s index.org README.org
		cd -
	    else
		echo "❌ $DIR"
		mkdir -p $DIR
		mv $f $DIR/index.org
		cd $DIR
		ln -s index.org README.org
		cd -
	    fi
	    # 
	done
	mv index/index.org .
	sed -i 's/\(\.\/[^/]*\)\.html/\1/g' index.org
	ln -s index.org README.org
	rm -r index README
	;;
    *)
        # something
        echo "Invalid option: $1"
        exit 1
        ;;
esac
