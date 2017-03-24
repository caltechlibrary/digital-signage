#!/bin/bash

function checkApp() {
    APP_NAME=$(which $1)
    if [ "$APP_NAME" = "" ] && [ ! -f "./bin/$1" ]; then
        echo "Missing $APP_NAME"
        exit 1
    fi
}

function softwareCheck() {
    for APP_NAME in $@; do
        checkApp $APP_NAME
    done
}

function MakePage () {
    license="$1"
    nav="$2"
    content="$3"
    html="$4"
    # Always use the latest compiled mkpage
    APP=$(which mkpage)
    if [ -f ./bin/mkpage ]; then
        APP="./bin/mkpage"
    fi

    echo "Rendering $html"
    $APP \
	"title=text:mkpage: An experimental template and markdown processor" \
        "nav=$nav" \
        "content=$content" \
	    "sitebuilt=text:Updated $(date)" \
        "copyright=markdown:$(cat $license)" \
        page.tmpl > $html
}

function MakeSignageSite() {
    cd $DNAME
    echo $(pwd)
}

echo "Checking necessary software is installed"
softwareCheck mkpage
echo "Generating website index.html"
MakePage LICENSE nav.md README.md index.html
for DNAME in $(find . -type d -depth 1 | grep -v '.git'); do
    echo $(pwd)
    MakeSignageSite $DNAME
done
