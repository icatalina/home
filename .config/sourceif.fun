# vim: syntax=sh filetype=sh

# Sources a file if it exits
sourceif() {
  if [[ -s $1 ]]; then
    source $1
  fi
}
