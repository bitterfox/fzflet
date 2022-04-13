#!/bin/bash

case $FZFLET_MAVEN_SEARCH_CONTEXT in
    "GROUP" ) query="g:$FZFLET_MAVEN_SEARCH_GROUP" ;;
    "ARTIFACT" ) query="g:$FZFLET_MAVEN_SEARCH_GROUP%20AND%20a:$FZFLET_MAVEN_SEARCH_ARTIFACT" ;;
    * ) query=`echo "$1" | sed -r "s/\s/%20/g"` ;;
esac

if [ -z "$query" ]; then
    echo "Type to search maven repository $FZFLET_MAVEN_NAME"
    exit 0
fi

echo "[$FZFLET_MAVEN_NAME] Searching '$query'"

if [ -n "$FZFLET_MAVEN_EXTRA_QUERY" ]; then
    query="$query&$FZFLET_MAVEN_EXTRA_QUERY"
fi

current=0

option=""
case "$FZFLET_MAVEN_AUTH" in
    "basic" ) option="-u $FZFLET_MAVEN_USER:$FZFLET_MAVEN_PASSWORD" ;;
esac

while :; do
    result=`curl $option -s "${FZFLET_MAVEN_URL}/solrsearch/select?q=$query&rows=$FZFLET_MAVEN_BATCH_SIZE&start=$current&wt=json"`
    docs=`echo "$result" | jq '.response.docs'`

    if [ -z "`echo $docs | jq '.[]'`" ]; then
       break
    fi

    echo "$docs" | jq -r '.[] | {id, latestVersion} | to_entries | map("\(.value)") | join (":")'

    current=$((current + FZFLET_MAVEN_BATCH_SIZE))
done
