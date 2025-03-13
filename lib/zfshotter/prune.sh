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

load_module dataset_config
load_module logging


# zfshotter::prune_snapshot <dataset> <prune-policy> <options>
zfshotter::prune_snapshot() {
    local dataset="$1"
    local prune_policy="$2"
    local -n __options="$3"

    # TODO: Prune snapshots for the specified dataset using the given policy.
}

# zfshotter::prune_snapshot_from_file <filepath> <prune-policy>
zfshotter::prune_snapshot_from_file() {
    local filepath="$1"
    local prune_policy="$2"

    local -a datasets
    mapfile -t datasets < "$filepath"

    local dataset_config dataset
    for dataset_config in "${datasets[@]}"
    do
        local -A options

        dataset_config::parse options "$dataset_config"

        dataset="${options["dataset"]}"

        if ! dataset_config::boolean "${options["prune"]}" "yes"; then
            logging::debug "Skip pruning snapshots of $dataset"
            continue
        fi

        zfshotter::prune_snapshot "$dataset_config" "$prune_policy" options

        unset options
    done
}
