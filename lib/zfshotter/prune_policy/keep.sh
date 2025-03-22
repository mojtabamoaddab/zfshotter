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


load_module duration


# keep_all
#
# Keep all snapshots (no prune)
zfshotter::prune_policy::keep_all() {
    :
}


# keep_n <n>
#
# Keep the last n snapshots
zfshotter::prune_policy::keep_n() {
    head -n -"$1"
}

# keep_regex <pattern>
#
# Keep snapshots that match the specified regex pattern in their name
zfshotter::prune_policy::keep_regex() {
    local regex="$1"

    local line
    local timestamp snapshot
    while IFS= read -r line
    do
        read timestamp snapshot <<< "$line"

        if ! echo "${snapshot##*@}" | grep -qP "$regex"; then
            echo "$line"
        fi
    done
}

# keep_for <duration>
#
# Keep snapshots whitin specified duration
zfshotter::prune_policy::keep_for() {
    local keep_seconds="$(duration::parse "$1")"
    if [ $? -ne 0 ]; then
        logging::error "Invalid duration: '$1'"
        return 1
    fi

    local now="$(date +"%s")"
    local keep_date=$(( now - keep_seconds ))

    local line
    local timestamp snapshot
    while IFS= read -r line
    do
        read timestamp snapshot <<< "$line"

        if [ $timestamp -lt $keep_date ]; then
            echo "$line"
        fi
    done
}
