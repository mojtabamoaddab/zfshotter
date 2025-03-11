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

# zfshotter::take_snapshot <dataset-config> <snapshot-name>
zfshotter::take_snapshot() {
    local dataset_config="$1"
    local snapshot_name="$2"

    local -A options

    dataset_config::parse options "$1"

    local dataset="${options["dataset"]}"

    if ! dataset_config::boolean "${options["snapshot"]}" "yes"; then
        logging::debug "Skip taking snapshot from $dataset (snapshot=${options["snapshot"]})"
        return
    fi

    local zfs_options=""
    local log_message="Taking snapshot from $dataset"
    if boolean_option "${options["recursive"]}"; then
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

    local dataset_config
    for dataset_config in "${datasets[@]}"
    do
        zfshotter::take_snapshot "$dataset_config" "$(date +"$snapshot_format")"
    done
}
