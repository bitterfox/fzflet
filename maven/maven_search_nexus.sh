#!/bin/bash

query=`echo "$1" | sed -r "s/\s/%20/g"`

case $FZFLET_MAVEN_SEARCH_CONTEXT in
    "GROUP" ) query="group=$FZFLET_MAVEN_SEARCH_GROUP" ;;
    "ARTIFACT" ) query="group=$FZFLET_MAVEN_SEARCH_GROUP&name=$FZFLET_MAVEN_SEARCH_ARTIFACT" ;;
    * ) query="q=`echo "$1" | sed -r "s/\s/%20/g"`" ;;
esac

if [ "$query" == "q=" ]; then
    echo "Type to search maven repository $FZFLET_MAVEN_NAME"
    exit 0
fi

echo "[$FZFLET_MAVEN_NAME] Searching $query"

if [ -n "$FZFLET_MAVEN_EXTRA_QUERY" ]; then
    query="$query&$FZFLET_MAVEN_EXTRA_QUERY"
fi

continuationTokenParam=""
option=""
case "$FZFLET_MAVEN_AUTH" in
    "basic" ) option="-u $FZFLET_MAVEN_USER:$FZFLET_MAVEN_PASSWORD" ;;
esac
while :; do
    result=`curl $option -s "${FZFLET_MAVEN_URL}/service/rest/v1/search?$query$continuationTokenParam"`

    if [ -z "`echo $result | jq '.items[]'`" ]; then
       break
    fi

    echo "$result" | jq -r '.items[].assets[].path' | grep "pom$" | sed -r "s/(.*)\/(.*)\/(.*)\/.*.pom$/\1:\2:\3/" | sed -r "s/\//./g"

    continuationToken=`echo "$result" | jq -r '.continuationToken | select(. != null)'`
    if [ -z "$continuationToken" ]; then
        break;
    fi

    continuationTokenParam="&continuationToken=$continuationToken"
done | uniq
