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

load_module config_loader
load_module logging


__remote_ssh() {
    ssh $SSH_OPTIONS "$REMOTE_SSH_ADDRESS" "$@"
}

__dataset_remove_prefix() {
    local dataset="$1"
    local prefix="$2"

    [[ "$dataset" == "$prefix" ]] && return

    echo "${dataset#$prefix/}"
}

__dataset_add_prefix() {
    local prefix="$1"
    local dataset="$2"

    echo "$prefix${dataset:+/}$dataset"
}

# zfshotter::replicate <dataset> <remote-dataset>
zfshotter::replicate() {
    local dataset="$1"
    local remote_dataset="$2"

    local last_local_snapshot="$(zfs list -H -o name -t snapshot "${dataset}" | tail -n 1)"
    local last_remote_snapshot="$(__remote_ssh "zfs list -H -o name -t snapshot ${remote_dataset} | tail -n 1" 2>&1)"

    local last_local_snapshot_name="${last_local_snapshot##*@}"
    local last_remote_snapshot_name="${last_remote_snapshot##*@}"

    if [[ "${last_remote_snapshot}" == "cannot open '"*"': dataset does not exist" ]]; then
        logging::info "Initial snapshot transfer: Sending snapshot '$last_local_snapshot_name' from local dataset '$dataset' to remote dataset '$remote_dataset'."

        __remote_ssh zfs create -p "$(dirname "$remote_dataset")"

        local destination="$remote_dataset@$last_local_snapshot_name"
        if zfs send "$last_local_snapshot" | __remote_ssh zfs recv "$destination"; then
            logging::info "Successfully sent initial snapshot '$last_local_snapshot' to '$destination'."
        else
            logging::error "Failed to send initial snapshot '$last_local_snapshot' to '$destination'."
        fi
    else
        logging::info "Incremental snapshot transfer: Sending incremental snapshot from local dataset '$dataset' (last local: '$last_local_snapshot_name', last remote: '$last_remote_snapshot_name') to remote dataset '$remote_dataset'."

        if zfs send -R -I "$last_remote_snapshot_name" "$last_local_snapshot" | __remote_ssh zfs recv "$remote_dataset"; then
            logging::info "Successfully sent incremental snapshot '$last_local_snapshot' to remote dataset '$remote_dataset' (after '$last_remote_snapshot_name')."
        else
            logging::error "Failed to send incremental snapshot '$last_local_snapshot' to remote dataset '$remote_dataset' (after '$last_remote_snapshot_name')."
        fi
    fi
}

# zfshotter::replicate_from_replication_config <replication-config>
zfshotter::replicate_from_replication_config() {
    local replication_name="$1"

    config::load_replication_config "$replication_name"

    local -a datasets
    mapfile -t datasets < "$(config::datasets_path "$REPLICATION_DATASETS")"


    local dataset_config dataset remote_dataset
    for dataset_config in "${datasets[@]}"
    do
        local -A options

        dataset_config::parse options "$dataset_config"

        dataset="${options["dataset"]}"

        if ! dataset_config::boolean "${options["replicate"]}" "yes"; then
            logging::debug "Skipping replication for dataset '$dataset' as per configuration."
            continue
        fi

        remote_dataset="$(__dataset_remove_prefix "$dataset" "$LOCAL_DATASET_PREFIX_TO_REMOVE")"

        if [ -n "$REMOTE_DATASET_PREFIX" ]; then
            remote_dataset="$(__dataset_add_prefix "$REMOTE_DATASET_PREFIX" "$remote_dataset")"
        fi

        zfshotter::replicate "$dataset" "$remote_dataset"

        unset options
    done
}
