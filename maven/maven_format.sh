#!/bin/bash

format_maven() {
    cat <<EOF
<dependency>
    <group>$1</group>
    <artifact>$2</artifact>
    <version>$3</version>
</dependency>
EOF
}

format_gradle() {
    echo "$1:$2:$3"
}


kind="$1"

g="$2"
a="$3"
v="$4"
c="$5"

case "$kind" in
    "maven" ) format_maven $g $a $v $c ;;
    "gradle" ) format_gradle $g $a $v $c ;;
    "all" ) {
	echo "Maven:"
	format_maven $g $a $v $c
	echo
	echo "Gradle:"
	format_gradle $g $a $v $c
    }
esac
