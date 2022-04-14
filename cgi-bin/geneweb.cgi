#!/usr/bin/env bash

# The CGI working directory.
BIN_DIR=/opt/geneweb
BASE_DIR=/opt/geneweb/bases

# The language for the user interface.
LNG=${LNG:="en"}
LOGFILE=${LOGFILE:=$HTTPD_PREFIX/logs/gw.log}


fail_message ()
{
   echo 'Content-type: text/html'
   echo '<!DOCTYPE html> <html xmlns="http://www.w3.org/1999/xhtml">'
   echo '<body>'
   echo '<H3>Geneweb CGI failure</H3>'
   echo "<ul><li>$BIN_DIR</li>
         <li>$BASE_DIR</li>
         <li>$LANG</li>
         <li>$LOGFILE</li>
         </ul>"
   echo $(date +%F)'</p>'
   echo '</body></html>'
}
# cgi options
OPTIONS="-robot_xcl 19,60 -allowed_tags ./tags.txt -hd ./"

# call gwd
test -e $BIN_DIR || fail_message
touch ${LOGFILE} || fail_message
$BIN_DIR/gwd \
            -cgi $OPTIONS \
            -lang $LANG \
            -bd $BASE_DIR   2>$LOGFILE

# End of file, if this is missing the file is truncated
###################################################################################################
