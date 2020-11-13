#!/usr/bin/env bash

if [[ "$TERM" != "dumb" ]] && [[ "$TERM" != "" ]]; then
    TBLD=$(tput bold)
    TUNL=$(tput smul)
    TGRN=$(tput setaf 2)
    TYLW=$(tput setaf 3)
    TRED=$(tput setaf 1)
    TBLU=$(tput setaf 4)
    TWHT=$(tput setaf 7)
    TGRY=$(tput setaf 8)
    TOFF=$(tput sgr0)
    TDIM=$(tput dim)
    TBND=$TBLD
    TEPH=$TBND$TBLU
    TERR=$TBLD$TRED
    TWRN=$TBLD$TYLW
else
    TBLD=""
    TUNL=""
    TGRN=""
    TYLW=""
    TRED=""
    TBLU=""
    TWHT=""
    TOFF=""
    TDIM=""
    TBND=""
    TEPH=""
    TERR=""
fi
