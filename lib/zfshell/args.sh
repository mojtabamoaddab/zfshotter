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


zfshell::get_token_from_args() {
    local -n args="$1"
    local -a new_args

    local i=0
    while [[ "$i" -lt "${#args[@]}" ]]; do
        local arg="${args[$i]}"
        case "$arg" in
            --token)
                ((i++))
                local token="${args[$i]}"
                ;;
            *)
                new_args+=("$arg")
                ;;
        esac
        ((i++))
    done

    args=("${new_args[@]}")

    echo "$token"
}
