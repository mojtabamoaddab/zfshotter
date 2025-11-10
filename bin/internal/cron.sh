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


INTERNAL_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(dirname "$INTERNAL_SCRIPT_DIR")"
ZFSHOTTER_ROOT="$(dirname "$SCRIPT_DIR")"


source "$ZFSHOTTER_ROOT/lib/module_loader.sh"

load_module dataset_config


JOB_CONFIG_FILE="$1"
JOB_NAME="${JOB_CONFIG_FILE##*/}"
JOB_NAME="${JOB_NAME%.conf}"

source "$JOB_CONFIG_FILE"

dataset_config::boolean "$ENABLED" || exit 0

LOG_FILE="${LOG_FILE:-$LOG_DIR/$JOB_NAME.log}"

echo "$CRON_SCHEDULE root LOG_FILE=$LOG_FILE $SCRIPT_DIR/zfshotter.sh $JOB_NAME"
