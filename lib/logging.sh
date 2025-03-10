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


LOG_DATE_FORMAT="%Y-%m-%d %H:%M:%S"


DEFAULT_LOG_LEVEL="INFO"


LOG_LEVELS=(
    ["DEBUG"]=10
    ["INFO"]=20
    ["WARNING"]=30
    ["ERROR"]=40
    ["FATAL"]=50
)

LOG_LEVEL="${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}"

LOG_FILE="${LOG_FILE:-/dev/stderr}"


__log_date() {
    date +"$LOG_DATE_FORMAT"
}


logging::log() {
    local level_name="$1"
    local message="$2"

    local level="${LOG_LEVELS["$level_name"]}"

    if [ -n "$level" ] && [ "$level" -ge "${LOG_LEVELS["$LOG_LEVEL"]}" ]; then
        echo "[$(__log_date)] $level_name: $message" >> "$LOG_FILE"
    fi
}

logging::debug() {
    logging::log "DEBUG" "$1"
}

logging::info() {
    logging::log "INFO" "$1"
}

logging::warning() {
    logging::log "WARNING" "$1"
}

logging::error() {
    logging::log "ERROR" "$1"
}

logging::fatal() {
    logging::log "FATAL" "$1"
}
