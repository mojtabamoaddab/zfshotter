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


__base64_padding() {
    case "$(( ${#1} % 4 ))" in
        2) echo -n "$1==" ;;
        3) echo -n "$1=" ;;
        1) return 1 ;;
    esac
}

jwt::base64() {
    base64 | tr "+/" "-_" | tr -d "=\n"
}

jwt::base64_decode() {
    __base64_padding "$(cat - | tr -- "-_" "+/")" | base64 -d
}

jwt::hmac() {
    local hexsecret="$(echo "$1" | base64 -d | xxd -p | tr -d $'\n')"
    openssl dgst -sha256 -mac HMAC -macopt hexkey:"$hexsecret" -binary
}

jwt::generate() {
    local payload="$(echo -n "$1" | jwt::base64)"
    local secret="$2"
    local signature=$(echo -n "$_jwt_header.$payload" | jwt::hmac "$secret" | jwt::base64)

    echo "$_jwt_header.$payload.$signature"
}

jwt::validate() {
    local token="$1"
    local secret="$2"
    local header="$(echo -n "$token" | cut -d'.' -f1)"
    local payload="$(echo -n "$token" | cut -d'.' -f2)"
    local token_signature="$(echo -n "$token" | cut -d'.' -f3)"

    local signature="$(echo -n "$header.$payload" | jwt::hmac "$secret" | jwt::base64)"

    [[ "$token_signature" == "$signature" ]] || return 1
}

jwt::decode() {
    local payload="$(echo -n "$1" | cut -d'.' -f2)"

    echo "$payload" | jwt::base64_decode
}


_jwt_header="$(echo -n '{"alg":"HS256","typ":"JWT"}' | jwt::base64)"
