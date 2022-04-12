#!/bin/bash

basedir=`dirname $0`
. $basedir/util/common.sh

DEFAULT_RC_FILE='default${component}.rc'

# Setup initial rc file
generate_config() {
    component=$1
    if [ -n "$component" ]; then
        default_rc_file=`component=".$component" envsubst <<< ${DEFAULT_RC_FILE}`
    else
        default_rc_file=`component="" envsubst <<< ${DEFAULT_RC_FILE}`
    fi

    rc_path=`rc_path $component`

    echo "Checking rc file: $rc_path"
    if [ ! -f $rc_path ]; then
        echo "rc file is not found:" $rc_path
        echo "Generate rc file from $default_rc_file"
        touch $rc_path
        # RC file may contains some sensitive configuration like password or token
        chmod 600 $rc_path
        ls $basedir | while read subdir; do
            default_rc_path=$basedir/$subdir/$default_rc_file
            if [ -f $default_rc_path ]; then
                echo "# Generated from `realpath $default_rc_path`" >> $rc_path
                cat $default_rc_path >> $rc_path
                echo >> $rc_path
            fi
        done
    fi
}

generate_config
generate_config zsh
