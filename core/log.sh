#!/usr/bin/env bash

function di::log() {
	echo $1
}

function di::log::error() {
	COLOR=${2:-$TERR}
	echo
	echo "  ${COLOR}$1${TOFF}"
	echo
}

function di::log::warn() {
	COLOR=${2:-$TWRN}
	echo ${COLOR}$1${TOFF}
}

function di::log::header() {
	COLOR=${2:-$TBLD$TUNL}
	echo ${COLOR}$1${TOFF}
}

function di::log::em() {
	COLOR=${2:-$TBLD}
	echo ${COLOR}$1${TOFF}
}

function di::log::success() {
	COLOR=${2:-$TGRN}
	echo ${COLOR}$1${TOFF}
}

function di::log::dim() {
	COLOR=${2:-$TDIM}
	echo ${COLOR}$1${TOFF}
}

