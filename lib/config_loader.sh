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


ZFSHOTTER_ROOT_DIR="$(dirname "$MODULES_DIR")"
ZFSHOTTER_CONFIG_DIR="$ZFSHOTTER_ROOT_DIR/config"
ZFSHOTTER_JOBS_DIR="$ZFSHOTTER_CONFIG_DIR/jobs"
ZFSHOTTER_DATASETS_DIR="$ZFSHOTTER_CONFIG_DIR/datasets"


# zfsshotter::load_job_config <job-name>
config::load_job_config() {
    local job_name="$1"
    local job_path="$ZFSHOTTER_JOBS_DIR/$job_name.conf"
    if [ ! -f "$job_path" ]; then
        logging::fatal "Job configuration file '$job_path' for job '$job_name' does not exist."
        return 1
    fi
    logging::info "Loading job configuration for '$job_name' from '$job_path'."
    source "$job_path"
}

# zfsshotter::datasets_path <datasets-name>
config::datasets_path() {
    local datasets_name="$1"
    local datasets_path="$ZFSHOTTER_DATASETS_DIR/$datasets_name.conf"
    if [ ! -f "$datasets_path" ]; then
        echo "Datasets configuration file '$datasets_path' for datasets '$datasets_name' does not exist."
        return 1
    fi
    logging::info "Datasets configuration found at '$datasets_path'."
    echo "$datasets_path"
}
