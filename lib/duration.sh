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


duration::parse() {
    local duration_string="$1"
    local duration=0

    while [ -n "$duration_string" ]
    do
        if [[ "$duration_string" =~ ^([0-9]+)([wdhms])(.*)$ ]]; then
            local n="${BASH_REMATCH[1]}"
            local unit="${BASH_REMATCH[2]}"

            case "$unit" in
                w)
                    (( duration += n * 7 * 24 * 60 * 60 ))
                    ;;
                d)
                    (( duration += n * 24 * 60 * 60 ))
                    ;;
                h)
                    (( duration += n * 60 * 60 ))
                    ;;
                m)
                    (( duration += n * 60 ))
                    ;;
                s)
                    (( duration += n ))
                    ;;
            esac

            duration_string="${BASH_REMATCH[3]}"
        else
            return 1
        fi
    done

    echo "$duration"
}
