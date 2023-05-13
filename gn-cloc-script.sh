#!/bin/bash

# Gabriel N Cloc Script [Technical Assessment #2]
# Author: Gabriel N
# Date: May 05 2023

declare PKGMNGR=""
declare LOGLEVEL="warning"

function main() {
    while (( $# > 0 ))
    do
        GETOPT_ERROR=$(getopt --quiet --longoptions "loglevel:" -o "l" "$@" 2>&1)
        exitWithError INVALID_ARGUMENT "$GETOPT_ERROR"
        echo "$option_name"
        shift
    done

    determinePackageManager || exitWithError NO_PKG_MNGR
}

function logMessage() {
    return
}

function exitWithError() {
    local ERROR_ID="$1"
    local ERROR_CODE=1
    local ERROR_MSG=""

    case "$ERROR_ID" in
        INVALID_ARGUMENT)
            ERROR_MSG="$2"
            ;;
        
        NO_PKG_MNGR)
            ERROR_MSG="No valid package manager was found"
            ;;
    esac

    if [ -n "$ERROR_MSG" ]
    then
        echo "Fatal Error: $ERROR_MSG" >&2
    else
        echo "Fatal Error: $ERROR_ID" >&2
    fi

    return $ERROR_CODE
}

# Determines which package manager to use for checking and installing 
function determinePackageManager() {
    for PKGMNGR_SEARCH in dnf yum apt
    do
        if [ -x "$(which "$PKGMNGR_SEARCH")" ]
        then
            PKGMNGR="$PKGMNGR_SEARCH"
            break
        fi
    done

    [ -n "$PKGMNGR" ] && return 0

    return 1
}

function installPackage() {
    return
}

function checkPackage() {
    case "$PKGMNGR" in
        dnf|yum)
            "$PKGMNGR" -y -q install "$@"
            ;;
        
        apt)
            "$PKGMNGR" -y -q install "$@"
            ;;
    esac
}

main "$@"