#!/usr/bin/env bash

#***********************************************************************#
#  travis-ci.sh                                                         #
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

################
# Dependencies #
################

# Use GCC 4.8+ for better C++11 support
if ! [ "$PLATFORM" == "osx" ] && ! [ "$PLATFORM" == "iphone" ]; then 
	sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
	sudo apt-get -qq update
	if [ "$CXX" = "g++" ]; then 
		sudo apt-get install -qq g++-4.8;
		export CXX="g++-4.8" CC="gcc-4.8"
	fi
fi

# Dependencies for Android
if [ "$PLATFORM" == "android" ]; then 
	#export ANDROID_HOME=
	#export ANDROID_NDK_ROOT=
	mkdir -p platform/android/java/libs/armeabi
	mkdir -p platform/android/java/libs/x86
fi

# Dependencies for Blackberry 10
# *** TO FIX: Quit or accept licence agreement automatically
#if [ "$PLATFORM" == "bb10" ] || [ "$PLATFORM" == "all" ]; then 
#	# Around 400 MB download
#	export BB10_SDK_FILENAME=momentics-2.1.2-201503050937.linux.x86_64.run && wget --quiet -P /tmp/ https://developer.blackberry.com/native/downloads/fetch/$BB10_SDK_FILENAME
#	sudo bash /tmp/$BB10_SDK_FILENAME --quiet --nox11 <<END
#	y
#	END
#	# TODO: Finish this part
#fi

# Dependencies for Javascript
if [ "$PLATFORM" == "javascript" ]; then 
	sudo apt-get -qq install emscripten
	export EMSCRIPTEN_ROOT=$(em-config EMSCRIPTEN_ROOT)
fi

# Dependencies for Linux (incl. Server)
if [ "$PLATFORM" == "x11" ] || [ "$PLATFORM" == "server" ]; then 
	sudo apt-get -qq install scons pkg-config libx11-dev libxcursor-dev build-essential libasound2-dev libfreetype6-dev libgl1-mesa-dev libglu-dev libssl-dev libxinerama-dev
fi

# Dependencies for Windows
if [ "$PLATFORM" == "windows" ]; then 
	sudo apt-get -qq install mingw32 mingw-w64
fi


############
# Building #
############

# Debug
echo scons -j 4 platform=$PLATFORM tools=$TOOLS target=$TARGET bits=$BITS
# Standard compiling command
scons -j 4 platform=$PLATFORM tools=$TOOLS target=$TARGET bits=$BITS


##############
# Deployment #
##############

# Deploy the compilation
#if [ "$DEPLOY" == "yes" ]; then
	# TODO: 
	#  - http://docs.travis-ci.com/user/deployment/releases/
	#  - https://github.com/okamstudio/godot/wiki/compiling_batch_templates
	#  Use $TRAVIS_TAG for version
#fi
