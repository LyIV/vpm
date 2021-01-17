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
    "install")   sc_install ${@:2};;
    "list")      sc_list;;
    "move")      sc_update;;
    "uninstall") sc_uninstall ${@:2};;
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

function sc_install () {
  dist="start"

  case $1 in
    -h|--help)
      echo ""
      echo "USAGE"
      echo "    vpm install [OPTION] <plugin uri> <plugin name>"
      echo ""
      echo "OPTIONS"
      echo "    --start  -s    install plugin to start directory (default)"
      echo ""
      echo "    --opt    -o    install plugin to opt directory"
      ;;
    -s|--start)
      shift
      ;;
    -o|--opt)
      dist="opt"
      shift
      ;;
  esac

  if [[ ${1:-UNSET} = UNSET || ${2:-UNSET} ]]; then
    echo "argument error"
    exit 1
  else
    git clone ${1} ${plugins_directory}/${dist}/$2
    echo "- done -"
    echo ""
  fi
}

function sc_list () {
  echo "\n[ start ]"
  ls "${plugins_directory}/start"
  echo "\n[ opt ]"
  ls "${plugins_directory}/opt"
  echo ""
  echo "- done -"
}

function sc_move () {}

function sc_uninstall () {
  dist="start"

  case $1 in
    -h|--help)
      echo ""
      echo "USAGE"
      echo "    vpm uninstall [OPTION] <plugin name>"
      echo ""
      echo "OPTIONS"
      echo "    --start  -s    uninstall plugin from start directory (default)"
      echo ""
      echo "    --opt    -o    uninstall plugin from opt directory"
      ;;
    -s|--start)
      shift
      ;;
    -o|--opt)
      dist="opt"
      shift
      ;;
  esac

  if [[ ${1:-UNSET} = UNSET ]]; then
    echo "argument error"
    exit 1
  else
    rm -rfv ${plugins_directory}/${dist}/$1
    echo "- done -"
    echo ""
  fi
}

function sc_update () {
  current_directory=`pwd`

  for install_directory in `ls ${plugins_directory}`; do
    echo "\n>>> ${install_directory}"
    for plugin in `ls ${plugins_directory}/${install_directory}`; do
      echo "\nupdate: ${plugin}"
      cd ${plugins_directory}/${install_directory}/${plugin}
      git pull --rebase
      origin_uri=`git remote get-url origin`
      echo ""
    done
    echo "- done -"
  done

  cd $current_directory
}

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

