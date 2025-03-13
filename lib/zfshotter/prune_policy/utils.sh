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


# zfshotter::prune_policy::destroy
#
# Destroys snapshots read from standard input (timestamp snapshot).
zfshotter::prune_policy::destroy() {
    local line
    while IFS= read -r line
    do
        read timestamp snapshot <<< "$line"

        zfs destroy "$snapshot"
    done
}


# zfshotter::prune_policy::pipe <prune-policy>
#
# Executes a pipeline of prune policies from a given string
#
#
# prune-policy:
#     A string of policies separated by '|', e.g.,
#       'keep_regex "^manual" | keep_n 25'
zfshotter::prune_policy::pipe() {
    local prune_policy="$1"

    local -a policies
    mapfile -t policies <<< "$(echo "$prune_policy" | awk '{
        gsub(" +\| +", "\n");
        print;
    }')"

    local policy_pipe

    local policy
    for policy in "${policies[@]}"
    do
        policy="zfshotter::prune_policy::$policy"
        if [ -z "$policy_pipe" ]; then
            policy_pipe="$policy"
        else
            policy_pipe+=" | $policy"
        fi
    done

    eval "$policy_pipe"
}
