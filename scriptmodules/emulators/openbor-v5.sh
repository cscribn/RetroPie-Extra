#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="openbor-v5"
rp_module_desc="OpenBOR - Beat 'em Up Game Engine -Pi5 edition"
rp_module_help="OpenBOR games need to be extracted to function properly. Place your pak files in $romdir/ports/openbor and then run $rootdir/ports/openbor/extract.sh. When the script is done, your original pak files will be found in $romdir/ports/openbor/originals and can be deleted."
rp_module_licence="BSD https://raw.githubusercontent.com/DCurrent/openbor/refs/heads/master/LICENSE"
rp_module_repo="git https://github.com/DCurrent/openbor.git master"
rp_module_section="exp"
rp_module_flags="sdl1 !mali !x11 !rpi4"

function depends_openbor-v7533() {
    getDepends libsdl1.2-dev libsdl-gfx1.2-dev libogg-dev libvorbisidec-dev libvorbis-dev libpng-dev zlib1g-dev libvpx-dev
}

function sources_openbor-vv7533() {
    gitPullOrClone
}

function build_openbor-vv7533() {
    cmake -DBUILD_LINUX=ON USE_SDL=ON -DTARGET_ARCH="ARM64" -S . -B build.lin.arm64 && cmake --build build.lin.arm64 --config Release -- -j
    md_ret_require="$md_build/build.lin.arm64/OpenBOR"
}

function install_openbor-vv7533() {
    md_ret_files=(
       'build.lin.arm64/OpenBOR'
    )
}

function configure_openbor-vv7533() {
    mkRomDir "openbor"

    local dir
    for dir in ScreenShots Saves; do
        mkUserDir "$md_conf_root/$md_id/$dir"
        ln -snf "$md_conf_root/$md_id/$dir" "$md_inst/$dir"
    done

    ln -snf "$romdir/ports/$md_id" "$md_inst/Paks"
    ln -snf "/dev/shm" "$md_inst/Logs"
    addEmulator 0 "$md_id" "openbor" "$md_inst/OpenBOR %ROM%"

    addSystem "openbor" "OpenBOR" ".zip .ZIP .pak .PAK"
}