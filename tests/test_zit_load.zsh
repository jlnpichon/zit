#!/bin/zsh

setopt shwordsplit
SHUNIT_PARENT=$0

source ../zit.zsh

setUp() {
  ZIT_MODULES_PATH="mocks"
}

test_loading_module() {
  local result="$(zit-load "module" "dummy.zsh";
                  echo "ZIT_MODULES_LOADED: ${ZIT_MODULES_LOADED}")"
  local expect="$(cat <<EOF
Hello World!
ZIT_MODULES_LOADED: mocks/module
EOF
  )"
  assertEquals "${expect}" "${result}"
}

test_loading_module_from_non_standard_directory() {
  local result="$(ZIT_MODULES_PATH="mocks/test" zit-load "module" "dummy.zsh";
                  echo "ZIT_MODULES_LOADED: ${ZIT_MODULES_LOADED}")"
  local expect="$(cat <<EOF
Hello World!
ZIT_MODULES_LOADED: mocks/test/module
EOF
  )"
  assertEquals "${expect}" "${result}"
}

test_loading_sh_module() {
  local result="$(emulate sh -c 'zit-load "module" "dummy.sh"')"
  assertEquals "Hello World!" "${result}"
}

test_loading_bash_module() {
  local result="$(emulate bash -c 'zit-load "module" "dummy.bash"')"
  assertEquals "Hello World!" "${result}"
}

test_loading_module_with_space() {
  local result="$(zit-load "another module" "dummy.zsh")"
  assertEquals "Another Hello World!" "${result}"
}

test_missing_param_module_dir() {
  local result="$(zit-load)"
  assertEquals "[zit] Missing argument: Module directory" "${result}"
}

test_missing_param_dot_zsh() {
  local result="$(zit-load "module")"
  assertEquals "[zit] Missing argument: .zsh file" "${result}"
}

source ./shunit2/src/shunit2
