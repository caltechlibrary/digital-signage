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
    nav="$1"
    content="$2"
    html="$3"
    tmpl="$4"
    # Always use the latest compiled mkpage
    APP=$(which mkpage)
    if [ -f ./bin/mkpage ]; then
        APP="./bin/mkpage"
    fi

    echo "Generating $html"
    $APP \
	"title=text:Caltech Library Digital Signage" \
        "nav=$nav" \
        "content=$content" \
	    "sitebuilt=text:Updated $(date)" \
        $tmpl > $html
}

function MakeSignageSite() {
    start=$(pwd)
    cd $DNAME
    for FNAME in $(find . -type f | grep -E '.md$'); do
        MakePage nav.md $(basename $FNAME) $(basename $FNAME .md).html ../page.tmpl
    done
    cd $start
}

echo "Checking necessary software is installed"
softwareCheck mkpage
echo "Generating website index.html"
MakePage nav.md README.md index.html page.tmpl
echo "Generate website license.html"
MakePage nav.md "markdown:$(cat LICENSE)" license.html page.tmpl
echo "Generate signage sites"
for DNAME in $(find . -type d -depth 1 | grep -v '.git'); do
    MakeSignageSite $DNAME
done
