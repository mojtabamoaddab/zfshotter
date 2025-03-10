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


_MODULE_LOADER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$_MODULE_LOADER_DIR"


declare -A __MODULES

# load_module <module>
load_module() {
    local module="$1"
    if [ "${__MODULES["$module"]}" == "yes" ]; then
        return 0
    fi

    if [ -f "$MODULES_DIR/$module.sh" ]; then
        source "$MODULES_DIR/$module.sh"
    elif [ -d "$MODULES_DIR/$module" -a -f "$MODULES_DIR/$module/__module__.sh" ]; then
        source "$MODULES_DIR/$module/__module__.sh"
    else
        echo "Module not found: '$module'" >&2
        return 1
    fi

    __MODULES["$module"]="yes"
}
