#!/bin/bash
#set -x
d=${PWD}

if [ ! -d build.release ] ; then
    mkdir build.release
fi

# Detect system, set triplet. For now the triplet is hardcoded, w/o checks.
if [ "$(uname)" = "Darwin" ]; then
    is_mac=y
    triplet="mac-clang-x86_64"
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    is_linux=y
    triplet="linux-gcc-x86_64"
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ]; then
    is_win=y
    triplet="win-vs2012-x86_64"
else
    echo "not valid triplet found"
fi

extern_path=${d}/../extern/${triplet}
install_path=${d}/../install/${triplet}

if [ "${is_linux}" = "y" ] ; then
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${extern_path}/lib/
fi

if [ ! -d ${d}/sources ] ; then
    if [ "${is_linux}" = "y" ] || [ "${is_mac}" = "y" ] ; then
        ./build_unix_dependencies.sh
    fi
    if [ "${is_win}" = "y" ] ; then 
        ./build_win_dependencies.sh
    fi
fi

