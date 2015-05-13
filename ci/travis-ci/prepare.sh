#!/usr/bin/env bash

#***********************************************************************#
#  prepare.sh                                                           #
#***********************************************************************#
#                       This file is part of:                           #
#                           GODOT ENGINE                                #
#                    http://www.godotengine.org                         #
#***********************************************************************#
# Copyright (c) 2007-2015 Juan Linietsky, Ariel Manzur.                 #
#                                                                       #
# Permission is hereby granted, free of charge, to any person obtaining #
# a copy of this software and associated documentation files (the       #
# "Software"), to deal in the Software without restriction, including   #
# without limitation the rights to use, copy, modify, merge, publish,   #
# distribute, sublicense, and/or sell copies of the Software, and to    #
# permit persons to whom the Software is furnished to do so, subject to #
# the following conditions:                                             #
#                                                                       #
# The above copyright notice and this permission notice shall be        #
# included in all copies or substantial portions of the Software.       #
#                                                                       #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.#
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                #
#***********************************************************************#

###############
# Preparation #
###############

# Use GCC 4.8+ for better C++11 support
if ! [ "$PLATFORM" == "osx" ] && ! [ "$PLATFORM" == "iphone" ]; then
	if [ "$CXX" = "g++" ]; then
		export CXX="g++-4.8" CC="gcc-4.8"
	fi
	if [ "$BITS" == "32" ]; then
		export CFLAGS=-m32
		export CXXFLAGS=-m32
	fi
fi

# Android
if [ "$PLATFORM" == "android" ]; then
	echo before ANDROID_HOME = $ANDROID_HOME
	export ANDROID_HOME=$(dirname $(which android))
	echo after ANDROID_HOME = $ANDROID_HOME
	echo ANDROID_NDK_ROOT = $ANDROID_NDK_ROOT
	locate ndk
	#export ANDROID_NDK_ROOT=
	mkdir -p platform/android/java/libs/armeabi
	mkdir -p platform/android/java/libs/x86
fi

# Javascript
if [ "$PLATFORM" == "javascript" ]; then
	export EMSCRIPTEN_ROOT=$(dirname $(which emcc))
fi

# MacOSX & iOS
if [ "$PLATFORM" == "osx" ] || [ "$PLATFORM" == "iphone" ]; then
	brew install scons
fi

# Windows
#if [ "$PLATFORM" == "windows" ]; then
#	export MINGW32_PREFIX="/usr/lib/i586-mingw32msvc-"
#	if [ "$BITS" == "64" ]; then
#		export MINGW64_PREFIX="/usr/lib/i686-w64-mingw32-"
#	fi
#fi
