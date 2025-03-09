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
# along with ZFShoter. If not, see <http://www.gnu.org/licenses/>.


__trim_space_pipe() {
    sed -r -e "s/^[[:blank:]]+//" -e "s/[[:blank:]]+$//"
}

__trim_space() {
    echo "$1" | __trim_space_pipe
}

# dataset_config::parse <associative-array-name> <dataset-config>
#
# <dataset-config>: Dataset configuration string in the format:
#     dataset_name [; option1=value1 [; option2=value2 [...]]]
dataset_config::parse() {
    local -n __options=$1
    local dataset_config="$2"
    local -a array

    IFS=';' read -a array <<< "${dataset_config}"

    __options["dataset"]="$(__trim_space "${array[0]}")"

    local option
    for option in "${array[@]:1}"; do
        local key="$(echo "$option" | sed -r "s/^(.+?)=.*$/\1/" | __trim_space_pipe)"
        local value="$(echo "$option" | sed -r "s/^.*?=(.*)$/\1/" | __trim_space_pipe)"
        __options["$key"]="$value"
    done
}

# dataset_config::boolean <option> [<default-value>]
dataset_config::boolean() {
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
