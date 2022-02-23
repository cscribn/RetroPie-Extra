#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="easyrpg-player"
rp_module_desc="RPG Maker 2000/2003 - EasyRPG Player Interpreter"
rp_module_help="ROM Extension: .ldb\n\nYou need to unzip your RPG Maker games into subdirectories in $romdir/ports/easyrpg/games\n\nRTP file:\nExtract the RTP files from their respective .exe installers and then copy RTP 2000 files in $biosdir/rtp/2000 and RTP 2003 files in $biosdir/rtp/2003."
rp_module_licence="GPL3 https://raw.githubusercontent.com/EasyRPG/Player/master/COPYING"
rp_module_repo="git https://github.com/EasyRPG/Player.git master"
rp_module_section="exp"
rp_module_flags="!mali"

function depends_easyrpg-player() {
    getDepends cmake autoconf automake libtool doxygen libsdl2-dev libsdl2-mixer-dev libpng-dev libfreetype6-dev libboost-dev libpixman-1-dev libmpg123-dev libwildmidi-dev libvorbis-dev libopusfile-dev libsndfile1-dev libxmp-dev libspeexdsp-dev libharfbuzz-dev libfmt-dev zlib1g-dev libraspberrypi-dev libraspberrypi-bin 
}

function sources_easyrpg-player() { 
    gitPullOrClone 
}

function build_easyrpg-player() {
    sed -i 's#APPEND_STRING PROPERTY#APPEND PROPERTY#' "/home/pi/RetroPie-Setup/tmp/build/easyrpg-player/builds/cmake/Modules/FindSDL2.cmake"
    sed -i 's#INTERFACE_LINK_LIBRARIES "${SDL2PC_STATIC_LIBRARIES}")#INTERFACE_INCLUDE_DIRECTORIES "${SDL2PC_STATIC_LIBRARY_DIRS}")#' "/home/pi/RetroPie-Setup/tmp/build/easyrpg-player/builds/cmake/Modules/FindSDL2.cmake"

    cmake . -DCMAKE_BUILD_TYPE=Release -DPLAYER_BUILD_LIBLCF=ON
    cmake --build .

    md_ret_require="$md_build/easyrpg-player"
}

function install_easyrpg-player() {
    md_ret_files=(
        'easyrpg-player'
    )
}

function remove_easyrpg-player() {
    for x in liblcf; do
        rm -rf "/usr/include/$x"
        rm -rf "/usr/lib/$x"*
        rm -rf "/usr/lib/cmake/$x"
        rm -rf "/usr/lib/pkgconfig/$x"*
        rm -rf "/usr/share/mime/packages/$x"*
    done
}

function configure_easyrpg-player() {
    setConfigRoot "ports"

    mkRomDir "ports/easyrpg/games/"
    mkUserDir "$biosdir/rtp/2000"
    mkUserDir "$biosdir/rtp/2003"  

    addPort "$md_id" "easyrpg" "EasyRPG Player" "cd $romdir/ports/easyrpg/games/; RPG2K_RTP_PATH=$biosdir/rtp/2000/ RPG2K3_RTP_PATH=$biosdir/rtp/2003 $md_inst/easyrpg-player"
}
