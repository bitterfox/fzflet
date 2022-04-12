
BASEDIR=`dirname $0`

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

while :; do
    result=`curl $option -s "$FZFLET_MAVEN_URL/service/rest/v1/search?group=$g&name=$a&repository=nightly%20internal&sort=version$continuationTokenParam"`

    if [ -z "`echo $result | jq '.items[]'`" ]; then
       break
    fi

    g_path=`echo "$g" | sed -r "s/\./\//g"`
    paths=`echo "$result" | jq -r '.items[].assets[].path' | grep "pom$"`
    matched_path=`echo "$paths" | grep "$g_path/$a/$v/" | head -n 1`
    if [ -n "$matched_path" ]; then
        internal_version=`echo "$matched_path" | sed -r "s%$g_path/$a/$v/$a-(.*)\.pom%\1%"`
        break;
    fi

    continuationToken=`echo "$result" | jq -r '.continuationToken | select(. != null)'`
    if [ -z "$continuationToken" ]; then
        break;
    fi

    continuationTokenParam="&continuationToken=$continuationToken"
done

if [ -z "$internal_version" ]; then
    echo "Not found"
    exit 1
fi

result=`curl $option -s "$FZFLET_MAVEN_URL/service/rest/v1/search?group=$g&name=$a&version=$internal_version"`
# echo "$result"

if [ -z "$result" ]; then
   echo "Not found"
   exit 1
fi

#echo "$result"

#echo "Packaging: `echo "$result" | jq -r '.p'`"

#timestamp=`echo $result | jq '.timestamp'`
#echo "Timestamp: `date -d @$((timestamp / 1000))`"

if [ `command -v xml-to-json` ]; then
    pom_download_url=`echo "$result" | jq -r '.items[].assets[].downloadUrl' | grep "pom$" | head -n 1`
    #echo $pom_download_url

    curl $option -s "$pom_download_url" > /tmp/maven_preview_$g-$a-$v-pom.xml

    xml-to-json /tmp/maven_preview_$g-$a-$v-pom.xml > /tmp/maven_preview_$g-$a-$v-pom.json

    pomjson=`cat /tmp/maven_preview_$g-$a-$v-pom.json`

    echo "License: `echo "$pomjson" | jq -r '.project.licenses.license.name'` `echo $pomjson | jq -r '.project.licenses.license.url'`"

    echo "URL: `echo "$pomjson" | jq -r '.project.url'`"

    if [ -n "`echo "$pomjson" | jq -r '.project.scm | select (.!=null)'`" ]; then
        echo "SCM: `echo $pomjson | jq -r '.project.scm.url'` `echo $pomjson | jq -r '.project.scm.connection'`"
    fi

    if [ -n "`echo "$pomjson" | jq -r '.project.organization | select (.!=null)'`" ]; then
        echo "Organization: `echo $pomjson | jq -r '.project.organization.name'` `echo $pomjson | jq -r '.project.organization.url'`"
    fi
fi

#echo "Tags: `echo "$result" | jq -r '.tags | join(\", \")'`"

echo "Files:"
echo "$result" | jq -r '.items[].assets[].downloadUrl' | while read line; do
    filename=`echo "$line" | awk -F/ "{print $ NF}"`
    echo "    $filename $line"
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

$BASEDIR/maven_format.sh all $g $a $v
