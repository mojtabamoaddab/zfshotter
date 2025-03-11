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

load_module logging


ZSHOTTER_SNAPSHOT_FORMAT="zshotter-%Y%m%d-%H%M%S"

# zfshotter::take_snapshot <dataset> <snapshot-name> <options>
zfshotter::take_snapshot() {
    local dataset="$1"
    local snapshot_name="$2"
    local -n __options="$3"

    local zfs_options=""
    local log_message="Taking snapshot from $dataset"
    if boolean_option "${__options["recursive"]}"; then
        zfs_options+=" -r"
        log_message+=" (recursive)"
    fi

    logging::debug "$log_message"

    zfs snapshot $zfs_options "${dataset}@${snapshot_name}"
}

# zfshotter::take_snapshot_from_file <filepath> <snapshot-format>
zfshotter::take_snapshot_from_file() {
    local filepath="$1"
    local snapshot_format="${2:-$ZSHOTTER_SNAPSHOT_FORMAT}"

    local -a datasets
    mapfile -t datasets < "$filepath"

    local dataset_config dataset
    for dataset_config in "${datasets[@]}"
    do
        local -A options

        dataset_config::parse options "$dataset_config"

        dataset="${options["dataset"]}"

        if ! dataset_config::boolean "${options["snapshot"]}" "yes"; then
            logging::debug "Skip taking snapshot from $dataset (snapshot=${options["snapshot"]})"
            continue
        fi

        zfshotter::take_snapshot "$dataset" "$(date +"$snapshot_format")" options

        unset options
    done
}
