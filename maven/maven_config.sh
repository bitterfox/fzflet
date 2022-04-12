#!/bin/bash

if [ ${FZFLET_MAVEN_CONFIG:-0} -eq 0 ]; then
    basedir=`dirname $0`
    . $basedir/../util/common.sh

    . $basedir/default.rc
    load_config

    export FZFLET_MAVEN_BATCH_SIZE=${FZFLET_MAVEN_BATCH_SIZE:-${FZFLET_MAVEN_DEFAULT_BATCH_SIZE:-50}}

    url=${FZFLET_MAVEN_URL:-${FZFLET_MAVEN_DEFAULT_URL:-https://search.maven.org/}}
    while [ -z "$url" ]; do
        echo -n "Input url> "
        read url

        if [ $? -ne 0 ]; then
            exit 1
        fi
    done
    export FZFLET_MAVEN_URL=$url
    export FZFLET_MAVEN_EXTRA_QUERY=${FZFLET_MAVEN_EXTRA_QUERY:-${FZFLET_MAVEN_DEFAULT_EXTRA_QUERY:-}}

    if [ -z "${FZFLET_MAVEN_OPEN_URL+1}" ]; then
        export FZFLET_MAVEN_OPEN_URL=${FZFLET_MAVEN_DEFAULT_OPEN_URL:-'https://mvnrepository.com/artifact/{1}/{2}/{3}'}
    fi

    if [ -z "${FZFLET_MAVEN_AUTH+1}" ]; then
        export FZFLET_MAVEN_AUTH=$FZFLET_MAVEN_DEFAULT_AUTH
    fi
    case $FZFLET_MAVEN_AUTH in
        "basic" )
            if [ -n "${FZFLET_MAVEN_USER+1}" ]; then
                user=$FZFLET_MAVEN_USER
            else
                user=$FZFLET_MAVEN_DEFAULT_USER
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
                password=$FZFLET_MAVEN_DEFAULT_PASSWORD
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

    export FZFLET_MAVEN_SEARCH=${FZFLET_MAVEN_SEARCH:-${FZFLET_MAVEN_DEFAULT_SEARCH:-maven_search.sh}}
    export FZFLET_MAVEN_PREVIEW=${FZFLET_MAVEN_PREVIEW:-${FZFLET_MAVEN_DEFAULT_PREVIEW:-maven_preview.sh}}

    export FZFLET_MAVEN_CONFIG=1
fi
