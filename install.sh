#!/bin/bash

basedir=`dirname $0`
. $basedir/util/common.sh

DEFAULT_RC_FILE=default.rc

# Setup initial rc file
rc_path=`rc_path`
echo "Checking rc file: $rc_path"
if [ ! -f $rc_path ]; then
    echo "rc file is not found:" $rc_path
    echo "Generate rc file from default"
    touch $rc_path
    # RC file may contains some sensitive configuration like password or token
    chmod 600 $rc_path
    ls $basedir | while read subdir; do
        default_rc_path=$basedir/$subdir/default.rc
        if [ -f $default_rc_path ]; then
            echo "# Generated from `realpath $default_rc_path`" >> $rc_path
            cat $default_rc_path >> $rc_path
            echo >> $rc_path
        fi
    done
fi
