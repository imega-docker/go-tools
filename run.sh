#!/usr/bin/env bash

function usage() {
cat <<EOF
Usage: go-tool [options...]

Options:
 -e  Err
 -f  Print differences if formatting is different than gofmt
 -l  Linter
 -s  Silent mode (don't output anything)
 -v  Include vendor dir

 -h  This help text
EOF
}

if [ $# -lt 1 ];then
    usage && exit 1
fi

while getopts ":aefls?" opt; do
    case $opt in
        a)
            FMT=1
        ;;
        e)
            ERRChECK=1
        ;;
        f)
            FMT=1
        ;;
        l)
            LINT=1
        ;;
        s)
            SILENT=1
        ;;
        ?)
            usage && exit 1
        ;;
    esac
done

function listPkgs() {
    echo $(go list ./... | grep -v '/vendor/')
}

function listFiles() {
    echo $(find . -type f -name *.go)
}

function output() {
    if [ -z "$SILENT" ]; then
        return 0
    fi

    cat $TMP_FMP
    
    if [ -n "$TMP_FMP" ]; then
        cat $TMP_FMP
    fi
}

if [ -n "$FMT" ]; then
    TMP_FMP=$(mktemp)
    PKGS=$(listFiles)
    ! gofmt -d main.go > $TMP_FMP | cat $TMP_FMP 2>&1 | read || FAIL_FMP=1
fi

#output
echo $TMP_FMP
ls -la $TMP_FMP
