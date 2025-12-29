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


utils::is_array() {
    if declare -p "$1" &> /dev/null &&
        [[ "$(declare -p "$1")" == "declare -a "* ]]; then
        return 0
    fi

    return 1
}

# utils::boolean <option> [<default-value>]
utils::boolean() {
    local default_value="${2:-false}"
    local option="${1:-$default_value}"


    case "${option,,}" in
        1 | y | yes | \
        t | true)
            return 0;
            ;;

        0 | n | no | \
        f | false)
            return 1;
            ;;

        *)
            return 2;
            ;;

    esac
}
