#!/bin/sh
echo 'Content-type: text/html'
echo
echo '<!DOCTYPE html>'
echo '<html xmlns="http://www.w3.org/1999/xhtml">'
echo '<body>'
echo 'This is a test for cgi commands</p>'
echo $(date +%F-%H%M)'</p>'
echo '<ul>'
for i in "$@"; do
  echo '<li>'$i'</li>'
done
echo '</ul>'
echo '</body>'
echo '</html>'
