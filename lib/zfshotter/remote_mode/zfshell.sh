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


__zfshell_ssh() {
    local -a OPTS
    if [[ -n "$ZFSHELL_TOKEN" ]]; then
        OPTS+=("--token" "$ZFSHELL_TOKEN")
    fi

    remote::ssh "$@" "${OPTS[@]}"
}

remote::zfshell::last_snapshot() {
    __zfshell_ssh last-snapshot "$1" 2>&1
}

remote::zfshell::receive() {
    __zfshell_ssh receive "$1"
}

remote::zfshell::create() {
    __zfshell_ssh create "$1"
}
