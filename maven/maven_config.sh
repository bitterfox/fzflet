#!/bin/bash

if [ ${FZFLET_MAVEN_CONFIG:-0} -eq 0 ]; then
    basedir=`dirname $0`
    . $basedir/../util/common.sh

    . $basedir/default.rc
    load_config

    export FZFLET_MAVEN_CONTEXT=${FZFLET_MAVEN_CONTEXT:-${FZFLET_MAVEN_DEFAULT_CONTEXT:-DEFAULT}}

    export FZFLET_MAVEN_BATCH_SIZE=${FZFLET_MAVEN_BATCH_SIZE:-$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_BATCH_SIZE:-50}")}


    url=${FZFLET_MAVEN_URL:-$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_URL:-https://search.maven.org/}")}
    while [ -z "$url" ]; do
        echo -n "Input url> "
        read url

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_MAVEN_URL=$url
    export FZFLET_MAVEN_EXTRA_QUERY=${FZFLET_MAVEN_EXTRA_QUERY:-$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_EXTRA_QUERY:-}")}

    export FZFLET_MAVEN_NAME=${FZFLET_MAVEN_NAME:-$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_NAME:-$FZFLET_MAVEN_URL}")}

    if [ -z "${FZFLET_MAVEN_OPEN_URL+1}" ]; then
        export FZFLET_MAVEN_OPEN_URL=$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_OPEN_URL:-'https://mvnrepository.com/artifact/{1}/{2}/{3}'}")
    fi

    if [ -z "${FZFLET_MAVEN_AUTH+1}" ]; then
        export FZFLET_MAVEN_AUTH=$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_AUTH}")
    fi
    case $FZFLET_MAVEN_AUTH in
        "basic" )
            if [ -n "${FZFLET_MAVEN_USER+1}" ]; then
                user=$FZFLET_MAVEN_USER
            else
                user=$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_USER}")
            fi
            while [ -z "$user" ]; do
                echo -n "Input username for $url> "
                read user

                if [ $? -ne 0 ]; then
                    exit 1
                fi
            done
            export FZFLET_MAVEN_USER=$user

            if [ -n "${FZFLET_MAVEN_PASSWORD+1}" ]; then
                password=$FZFLET_MAVEN_PASSWORD
            else
                password=$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_PASSWORD}")
            fi
            while [ -z "$password" ]; do
                echo -n "Input password for $url> "
                read -s password

                if [ $? -ne 0 ]; then
                    exit 1
                fi
            done
            export FZFLET_MAVEN_PASSWORD=$password
            ;;
    esac

    export FZFLET_MAVEN_SEARCH=${FZFLET_MAVEN_SEARCH:-$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_SEARCH:-maven_search.sh}")}
    export FZFLET_MAVEN_PREVIEW=${FZFLET_MAVEN_PREVIEW:-$(eval echo "\${FZFLET_MAVEN_${FZFLET_MAVEN_CONTEXT}_PREVIEW:-maven_preview.sh}")}

    export FZFLET_MAVEN_CONFIG=1
fi
