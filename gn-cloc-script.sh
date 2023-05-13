#!/bin/bash

# Gabriel N Cloc Script [Technical Assessment #2]
# Author: Gabriel N
# Date: May 05 2023

declare PKGMNGR=""
declare LOGLEVEL="warning"

function main() {
  options=$(getopt -o h,f,a,A,o,O,p,P,m,M,r:,l,v,z,Z -l help,fix,alt,native,list,revert:,verbose -- "$@") || return 16

  eval set -- "$options"

  # Do argument things
  while true; do
    case "$1" in
    esac
  done
  while (( $# > 0 ))
  do
    GETOPT_ERROR=$(getopt --quiet -l "loglevel:" -o "l" "$@" 2>&1 | grep -v -- --help)
    [ -n "$GETOPT_ERROR" ] && exitWithError INVALID_ARGUMENT "$GETOPT_ERROR"
    echo "$option_name"
    shift
  done

  # determinePackageManager || exitWithError NO_PKG_MNGR
  # checkPackage cloc || installPackage cloc || exitWithError MISSING_DEP
  # checkPackage mailx || installPackage mailx || exitWithError MISSING_DEP
}

function logMessage() {
    return
}

function exitWithError() {
  local ERROR_ID="$1"
  local ERROR_CODE=1
  local ERROR_MSG=""

  case "$ERROR_ID" in
    INVALID_ARGUMENT) shift; ERROR_MSG="$@";;
    NO_PKG_MNGR) shift; ERROR_MSG="No valid package manager was found";;
    MISSING_DEP) shift; ERROR_MSG="Failed to install missing dependency: $@";;
  esac

  [ -n "$ERROR_MSG" ] \
    && echo "Fatal Error: $ERROR_MSG" >&2 \
    || echo "Fatal Error: $ERROR_ID" >&2

  return $ERROR_CODE
}

# Determines which package manager to use for checking and installing 
function determinePackageManager() {
  for PKGMNGR_SEARCH in dnf yum apt pkg pacman; do
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
  case "$PKGMNGR" in
    dnf|yum) sudo -n "$PKGMNGR" -y -q install "$@";;
    apt) sudo -n apt -y -q install "$@";;
    pkg) sudo -n pkg -y -q install "$@";;
    pacman) sudo -n pacman -y -q -S install "$@";;
  esac
}

function checkPackage() {
  case "$PKGMNGR" in
    dnf|yum) rpm -q info "$@" >/dev/null;;
    apt) apt -y -q install "$@";;
    pkg) pkg -y -q install "$@";;
    pacman) pacman -y -q install "$@";;
  esac
}

main "$@"