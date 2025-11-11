function listVars() {
  # From shell variables
  for var in ${(k)parameters[(I)CS*]}; do
    print "\$$var = ${(P)var}"
  done

  # From environment variables
  for envvar in ${(k)environ[(I)CS*]}; do
    print "\$$envvar = ${(P)envvar}"
  done
}
