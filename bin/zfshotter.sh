#!/usr/bin/env bash

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


_USAGE_LINE="Usage: $0 JOB_NAME"

_DESCRIPTION="\
ZFShotter is a utility designed to automate the creation of ZFS snapshots and
replicate them to remote servers"

_HELP="\
$_USAGE_LINE

$_DESCRIPTION

Arguments:
    JOB_NAME
        The name of the job to run.

Options:
    -h	--help
        Display this help and exit
"

_short_help() {
    echo "$_USAGE_LINE"
    echo "Try '$0 --help' for more information"
}

_full_help() {
    echo "$_HELP"
}


OPTIONS=$(getopt --name "$0" --options "h" --longoptions "help" -- "$@")

if [ $? -ne 0 ]; then
    _short_help >&2
    exit 1
fi

eval set -- "$OPTIONS"


while true
do
    case "$1" in
        -h | --help)
            _full_help
            exit
            ;;

        --)
            shift
            break
            ;;

    esac
done


JOB_NAME="$1"

if [ -z "$JOB_NAME" ]; then
    _short_help >&2
    exit 1
fi


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZFSHOTTER_ROOT="$(dirname "$SCRIPT_DIR")"

source "$ZFSHOTTER_ROOT/lib/module_loader.sh"

load_module config_loader
load_module logging
load_module zfshotter
load_module utils


_check_replication_configs() {
    local replication
    for replication in "$@"
    do
        config::replication_path "$replication"
    done
}

config::load_job_config "$JOB_NAME" && \
    SNAPSHOT_DATASETS_PATH="$(config::datasets_path "$SNAPSHOT_DATASETS")" && \
    PRUNE_DATASETS_PATH="$(config::datasets_path "$PRUNE_DATASETS")" && \
    _check_replication_configs "${REPLICATIONS[@]}" || exit 1


logging::info "Started job $JOB_NAME"


logging::info "Started taking snapshots"
zfshotter::take_snapshot_from_file "$SNAPSHOT_DATASETS_PATH" "$SNAPSHOT_FORMAT"
logging::info "Finished taking snapshots"


logging::info "Started pruning snapshots"
if utils::is_array PRUNE_POLICY; then
    zfshotter::prune_snapshot_from_file "$PRUNE_DATASETS_PATH" "${PRUNE_POLICY[@]}"
else
    zfshotter::prune_snapshot_from_file "$PRUNE_DATASETS_PATH" "$PRUNE_POLICY"
fi
logging::info "Finished pruning snapshots"


logging::info "Started replicating snapshots"
for replication in "${REPLICATIONS[@]}"
do
    logging::info "Started replication: '$replication'"
    zfshotter::replicate_from_replication_config "$replication"
    logging::info "Finished replication: '$replication'"
done
logging::info "Finished replicating snapshots"


logging::info "Finished job $JOB_NAME"
