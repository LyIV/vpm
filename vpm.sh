#!/bin/zsh

set -eu

plugins_directory="${HOME}/.vim/pack/vpm"
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
      echo "$0 - ${version}"
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

#
# subcommands
#
function sc_export () {
  current_directory=`pwd`
  
  for install_directory in `ls ${plugins_directory}`; do
    echo "mkdir -p ~/.vim/pack/vpm/${install_directory}"
    for plugin in `ls ${plugins_directory}/${install_directory}`; do
      cd ${plugins_directory}/${install_directory}/${plugin}
      origin_uri=`git remote get-url origin`
      echo "git clone $origin_uri ${plugin}"
    done
    echo ""
  done

  cd $current_directory
}

function sc_install () {}

function sc_list () {
  echo "\n[ start ]"
  ls "${plugins_directory}/start"
  echo "\n[ opt ]"
  ls "${plugins_directory}/opt"
  echo ""
  echo "- done -"
}

function sc_move () {}

function sc_uninstall () {}

function sc_update () {}

#
# init
#
function init () {
  dist=("start" "opt")

  for install_directory in ${dist[@]}; do
    if [[ ! -e ${plugins_directory}/${install_directory} ]]; then
      echo "init: create ${plugins_directory}/${install_directory}"
      mkdir -p ${plugins_directory}/${install_directory}
      echo "- done -"
      echo ""
    fi
  done
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

