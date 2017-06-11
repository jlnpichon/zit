#!/bin/zsh

setopt shwordsplit
SHUNIT_PARENT=$0

source ../zit.zsh

setUp() {
  # mocking real zit functions
  zit-install() { echo "zit-install" "${1}" "${2}" }
  zit-load() { echo "zit-load" "${1}" "${2}" }
}

test_repo_directory() {
  local result=$(zit-install-load "https://github.com/m45t3r/zit" "zit")
  local expect=$(cat <<EOF
zit-install https://github.com/m45t3r/zit zit
zit-load zit *.zsh
EOF
  )
  assertEquals "${expect}" "${result}"
}

test_repo_directory_dotzsh() {
  local result=$(zit-install-load "https://github.com/m45t3r/zit" "zit" "zit.zsh")
  local expect=$(cat <<EOF
zit-install https://github.com/m45t3r/zit zit
zit-load zit zit.zsh
EOF
  )
  assertEquals "${expect}" "${result}"
}

source ./shunit2/src/shunit2