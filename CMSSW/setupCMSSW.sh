#!/bin/bash

STOP=""

VARS=""

function addVar
{
    VARS=$VARS" "$1"="$2
}

function execute 
{
    if [ -z "$STOP" ]; then
        echo -n $@ " ... "
        out=$(eval $@ 2>&1)
        ret=$?

        if [ $ret -eq 0 ]; then
            echo "ok"
        else
            echo "error"
            STOP=$out
        fi
    fi
}

cd $BASEDIR/CMSSW

export SCRAM_ARCH=slc6_amd64_gcc491
addVar SCRAM_ARCH $SCRAM_ARCH

execute "scramv1 project CMSSW CMSSW_7_3_4"
cd CMSSW_7_3_4/src

execute "scramv1 runtime -sh"
#execute "git cms-init"

#execute "wget -q -O - https://github.com/matt-komm/Pxl/archive/3.5.1.tar.gz | tar xvzf -"
#execute "mv Pxl-3.5.1 Pxl"

#execute "git clone --branch plugin-based https://github.com/matt-komm/EDM2PXLIO.git"
execute git cms-merge-topic matt-komm:ST_EA
execute echo "EDM2PXLIO" >> .git/info/sparse-checkout
execute echo "Pxl" >> .git/info/sparse-checkout
execute git read-tree -mu HEAD

execute "scram b -j10"

cd $BASEDIR

