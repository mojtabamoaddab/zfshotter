# Copyright (C) 2025 Mojtaba Moaddab
#
# This file is part of ZFShotter.
#
# ZFShotter is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ZFShotter is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ZFShotter. If not, see <http://www.gnu.org/licenses/>.


[ -n "$_LIB_MODULE_LOADER" ] && return || readonly _LIB_MODULE_LOADER=1


_MODULE_LOADER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$_MODULE_LOADER_DIR"


declare -A __MODULES

# load_module <module>
load_module() {
    local module="$1"

    local absolute_module
    if [ "${module:0:1}" == "/" ]; then
        absolute_module="$module"
    elif [[ "$module" =~ ^(\.|\.\.)(/|$) ]]; then
        local caller_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
        absolute_module="$(realpath "$caller_dir/$module")"
        unset caller_dir
    else
        absolute_module="$MODULES_DIR/$module"
    fi


    local module_file

    if [ -f "$absolute_module.sh" ]; then
        module_file="$absolute_module.sh"
    elif [ -d "$absolute_module" -a -f "$absolute_module/__module__.sh" ]; then
        module_file="$absolute_module/__module__.sh"
    else
        echo "Module not found: '$module'" >&2
        return 1
    fi


    if [ "${__MODULES["$module_file"]}" == "yes" ]; then
        return 0
    fi
    __MODULES["$module_file"]="yes"
    source "$module_file"
}
