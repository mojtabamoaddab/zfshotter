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

load_module jwt
load_module utils


__check_acl_rule() {
    local dataset="$1"
    local rule="$2"

    local rule_dataset="$(echo "$rule" | jq -r '.dataset')"
    local recursive="$(echo "$rule" | jq '.recursive')"

    if [[ "$dataset" == "$rule_dataset" ]]; then
        return 0
    elif utils::boolean "$recursive" && [[ "$dataset" == "$rule_dataset"/* ]]; then
        return 0
    else
        return 1
    fi
}

__filter_acl_rules() {
    local action="$1"
    local acl="$2"

    echo "$acl" | jq -c '.[] | select(.actions == "all")'
    echo "$acl" | jq -c ".[] | select(.actions | index(\"$action\"))"
}

alias zfshell::validate_token=jwt::validate

# zfshell::authorize <action> <dataset> <acl>
zfshell::authorize() {
    local action="$1"
    local dataset="$2"
    local acl="$3"

    local rule

    while IFS= read -r rule; do
        if __check_acl_rule "$dataset" "$rule"; then
            return 0
        fi
    done < <(__filter_acl_rules "$action" "$acl")

    return 1
}
