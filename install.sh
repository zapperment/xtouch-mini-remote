#!/usr/bin/env bash

function echo_red() {
  echo -e "\033[1;31m$1\033[0m"
}

function echo_bold() {
  echo -e "\033[1m$1\033[0m"
}

if [ ! "$(uname)" == "Darwin" ]; then
  echo_red "Sorry, this install script only works on macOS!"
  echo "On windows or other systems, you'll have to copy"
  echo "the files from the src directory over yourself."
  echo "More information: https://forum.reasontalk.com/viewtopic.php?t=7514815"
  exit 1
fi

USER_NAME=$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

REMOTE_DIR="/Users/${USER_NAME}/Library/Application Support/Propellerhead Software/Remote"

if [ ! -d "${REMOTE_DIR}" ]; then
  echo_red "Error – no Reason!"
  echo "Reason does not seem to be installed on this system – directory not found:"
  echo "${REMOTE_DIR}"
  exit 1
else
  echo_bold "Reason is installed, using remote dir:"
  echo "${REMOTE_DIR}"
fi

echo ""

CODECS_TARGET_DIR="${REMOTE_DIR}/Codecs/Lua Codecs/Behringer"

if [ ! -d "${CODECS_TARGET_DIR}" ]; then
  echo_bold "Creating codecs dir:"
  echo "${CODECS_TARGET_DIR}"
  mkdir -p "${CODECS_TARGET_DIR}"
else
  echo_bold "Using existing codecs dir:"
  echo "${CODECS_TARGET_DIR}"
fi

echo ""

MAPS_TARGET_DIR="${REMOTE_DIR}/Maps/Behringer"

if [ ! -d "${MAPS_TARGET_DIR}" ]; then
  echo_bold "Creating maps dir:"
  echo "${MAPS_TARGET_DIR}"
  mkdir -p "${MAPS_TARGET_DIR}"
else
  echo_bold "Using existing maps dir:"
  echo "${MAPS_TARGET_DIR}"
fi

echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

CODECS_SOURCE_DIR="${SCRIPT_DIR}/src/codecs"
MAPS_SOURCE_DIR="${SCRIPT_DIR}/src/maps"

echo_bold "Copying files:"

cp -v "${CODECS_SOURCE_DIR}/"* "${CODECS_TARGET_DIR}/"
cp -v "${MAPS_SOURCE_DIR}/"* "${MAPS_TARGET_DIR}/"
