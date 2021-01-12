#!/bin/zsh

set -eu

install_directory="$HOME/.vim/pack/vpm"
version="1.0"

#
# usage
#
function show_help () {
  echo "FLAGS"
  echo "    --help   -h    show help"
  echo ""
  echo "    --v            show version"
  echo ""
  echo "SUBCOMMANDS"
  echo "    export         export plugin list to the text file"
  echo ""
  echo "    install        install plugin"
  echo ""
  echo "    list           show plugin list"
  echo ""
  echo "    move           move plugin"
  echo ""
  echo "    uninstall      uninstall plugin"
  echo ""
  echo "    update         update plugins"

  exit 1
}

#
# flags
#
function parse_flags () {
  # todo: use getopts
  case $1 in
    -h|--help)
      show_help
      ;;
    -v|--version)
      echo "$0 - $version"
      ;;
    *)
      echo "parse error (try: vpm --help)"
      exit 1
      ;;
  esac
}

#
# parse args
#
function parse_args () {
  case $1 in
    "export")    sc_export;;
    "install")   sc_install;;
    "list")      sc_list;;
    "move")      sc_update;;
    "uninstall") sc_uninstall;;
    "update")    sc_update;;

    *)           parse_flags $@;;
  esac
}

function export () {}
function sc_install () {}
function sc_list () {}
function sc_move () {}
function sc_uninstall () {}
function sc_update () {}

#
# init
#
function init () {
  if [[ ! -e $install_directory ]]; then
    echo "make install directory: $install_directory"
    mkdir $install_directory
    echo "- done -"
    echo ""
  fi
}

#
# main
#
function main () {
  if [[ ${1:-UNSET} = UNSET ]]; then
    echo "try: vpm --help"
  else
    parse_args $@
  fi
}

# ------------------------- #
init
main $@

