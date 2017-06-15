# Compile ZSH completion cache, ZSH config files and loaded Zit modules in
# background, so it shouldn't affect ZSH interactive load.
# This serves most as an example on how to do it, and probably needs some
# adaptation depending on your needs.
# Inspired in https://github.com/Eriner/zim/blob/master/templates/zlogin
(
  # Function to determine the need of a zcompile. If the .zwc file
  # does not exist, or the base file is newer, we need to compile.
  # These jobs are asynchronous, and will not impact the interactive shell
  zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
      zcompile ${1}
    fi
  }

  setopt EXTENDED_GLOB

  # zcompile the completion cache; significant speedup.
  for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.); do
    zcompare ${file}
  done

  # zcompile ZSH config files
  for file in ${ZDOTDIR:-${HOME}}/.{zlogin,zlogout,zprofile,zshenv,zshrc}; do
    zcompare ${file}
  done

  # compile Zit plugins
  for module_dir in ${ZIT_MODULES_LOADED}; do
    for file in ${module_dir}/**/*.zsh; do
      zcompare ${file}
    done
  done

) &!