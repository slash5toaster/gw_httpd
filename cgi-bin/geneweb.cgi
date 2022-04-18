#!/usr/bin/env bash

# The CGI working directory.
BIN_DIR=/opt/geneweb
BASE_DIR=/opt/geneweb/bases

# parse the query string!!
saveIFS=$IFS
IFS='=&'
PARAMS=($QUERY_STRING)
IFS=$saveIFS
if [[ ${#PARAMS[@]} -gt 0 ]]; then
  for q in "${!PARAMS[@]}"; do
    if [[ $(($q % 2)) -eq 0  ]]; then
      # dereference item
      ${!PARAMS[$q]}=${PARAMS[$q+1]}
    fi
  done
fi

# The language for the user interface.
lang=${lang:="en"}
LOGFILE=${LOGFILE:=$HTTPD_PREFIX/logs/gw.log}


fail_message ()
{
   echo 'Content-type: text/html'
   echo '<!DOCTYPE html> <html xmlns="http://www.w3.org/1999/xhtml">'
   echo '<body>'
   echo '<H3>Geneweb CGI failure</H3>'
   echo "<ul><li>$BIN_DIR</li>
         <li>$BASE_DIR</li>
         <li>$lang</li>
         <li>$LOGFILE</li>
         </ul>"
   echo $(date +%F)'</p>'
   echo '</body></html>'
}
# cgi options
OPTIONS="-robot_xcl 19,60 -allowed_tags ./tags.txt -hd ./"

# call gwd
test -e $BIN_DIR  || fail_message
test -z $b  || fail_message
touch -m $LOGFILE || fail_message


$BIN_DIR/gwd \
            -cgi $OPTIONS \
            -lang $lang \
            -bd $BASE_DIR/$b   2>>$LOGFILE \
|| fail_message

# End of file, if this is missing the file is truncated
###################################################################################################
