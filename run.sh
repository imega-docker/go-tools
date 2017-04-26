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
    echo $(find ./tests -type f -name *.go)
}

function output() {
    if [ -n "$SILENT" ]; then
        return 0
    fi

    if [ -n "$FAIL_FMT" ]; then
        cat $TMP_FMT
    fi
}

if [ -n "$FMT" ]; then
    TMP_FMT=$(mktemp)
    gofmt -d $(listFiles) > $TMP_FMT
    ! cat $TMP_FMT 2>&1 | read || FAIL_FMT=1
fi

output
