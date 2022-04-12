#!/bin/bash

basedir=`dirname $0`

g=$1
a=$2
v=$3

echo "$g:$a:$v"

#echo "Group: $g"
#echo "Artifact: $a"
#echo "Version: $v"

option=""
case "$FZFLET_MAVEN_AUTH" in
    "basic" ) option="-u $FZFLET_MAVEN_USER:$FZFLET_MAVEN_PASSWORD" ;;
esac
result=`curl $option -s "${FZFLET_MAVEN_URL}/solrsearch/select?q=g:$g%20AND%20a:$a%20AND%20v:$v&rows=20&wt=json" | jq '.response.docs[]'`

if [ -z "$result" ]; then
   echo "Not found"
   exit 1
fi

echo "Packaging: `echo "$result" | jq -r '.p'`"

timestamp=`echo $result | jq '.timestamp'`
echo "Timestamp: `date -d @$((timestamp / 1000))`"

rootpath="`echo $g | sed -r 's#\.#/#g'`/$a/$v/"

if [ `command -v xml-to-json` ]; then
    pompath="$rootpath$a-$v.pom"

    curl $option -s "$FZFLET_MAVEN_URL/remotecontent?filepath=$pompath" > /tmp/maven_preview_$g-$a-$v-pom.xml

    xml-to-json /tmp/maven_preview_$g-$a-$v-pom.xml > /tmp/maven_preview_$g-$a-$v-pom.json

    pomjson=`cat /tmp/maven_preview_$g-$a-$v-pom.json`

    echo "License: `echo $pomjson | jq -r '.project.licenses.license.name'` `echo $pomjson | jq -r '.project.licenses.license.url'`"

    echo "URL: `echo $pomjson | jq -r '.project.url'`"

    if [ -n "`echo $pomjson | jq -r '.project.scm | select (.!=null)'`" ]; then
        echo "SCM: `echo $pomjson | jq -r '.project.scm.url'` `echo $pomjson | jq -r '.project.scm.connection'`"
    fi

    if [ -n "`echo $pomjson | jq -r '.project.organization | select (.!=null)'`" ]; then
        echo "Organization: `echo $pomjson | jq -r '.project.organization.name'` `echo $pomjson | jq -r '.project.organization.url'`"
    fi
fi

echo "Tags: `echo "$result" | jq -r '.tags | join(\", \")'`"

echo "Files:"
echo "$result" | jq -r '.ec[]' | while read line; do
    filepath="$rootpath$a-$v$line"
    echo "    $FZFLET_MAVEN_DEFAULT/remotecontent?filepath=$filepath"
done | sort

if [ `command -v xml-to-json` ]; then
    echo "Description:"
    echo $pomjson | jq -r '.project.description' | while read line; do
        echo "    $line"
    done

    echo "Dependencies:"
    echo $pomjson | jq -r '.project.dependencies.dependency[] | {groupId, artifactId, version, scope} | to_entries | map ("\(.value)") | join(":")' | sed -r "s/:null//g" | while read line; do
        echo "    $line"
    done | sort
fi

$basedir/maven_format.sh all $g $a $v
