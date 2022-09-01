#!/usr/bin/env bash

echo 'Content-type: text/html'
echo
echo '<!DOCTYPE html>'
echo '<html xmlns="http://www.w3.org/1999/xhtml">'
echo '<body>'
echo 'This is a test for cgi commands</p>'
echo $(date +%F-%H%M)'</p>'

declare -A GW_PARAMS

# parse the query string!!
saveIFS=$IFS
IFS='=&'
PARAMS=($QUERY_STRING)
IFS=$saveIFS

if [[ ${#PARAMS[@]} -gt 0 ]]; then
  echo '<h3>Input parameters</h3>'
  echo '<ol start=0 >'
  for q in "${!PARAMS[@]}"; do
    # echo '<li>'${PARAMS[$q]}'</li>'
    if [[ $(($q % 2)) -eq 0  ]]; then
      # echo '<li>'${PARAMS[$q]}'='${PARAMS[$q+1]}'</li>'
      GW_PARAMS[${PARAMS[$q]}]=${PARAMS[$q+1]}
      echo '<li>'${PARAMS[$q]}'</li>'
      echo '<ul><li>'${GW_PARAMS[${PARAMS[$q]}]}'</li></ul>'
    fi
  done
  echo '</ol>'
fi

##########

echo '<h3>Geneweb Variables</h3>'
echo '<ol start=0 >'
echo '<li> base is ' ${GW_PARAMS[b]} '</li>'
echo '<li> lang is ' ${GW_PARAMS[lang]} '</li>'
echo '<li> id is ' ${GW_PARAMS[i]} '</li>'
echo '<li> method is ' ${GW_PARAMS[m]} '</li>'
echo '<li> person name (p) is ' ${GW_PARAMS[p]} '</li>'
echo '<li> Family name is  ' ${GW_PARAMS[n]} '</li>'
echo '</ol>'

###################
echo '<h3>Environment variables</h3>'
echo '<ul>'

# print all environment variables
saveIFS=$IFS
IFS=$'\n\t'
for i in $(env | sort); do
  echo '<li>'$i'</li>'
done
IFS=$saveIFS

echo '</ul>'
echo '</body>'
echo '</html>'
