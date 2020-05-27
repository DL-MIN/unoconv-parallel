#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# unoconv-parallel.sh
# @package   unoconv-parallel
# @author    Lars Thoms <lars.thoms@uni-hamburg.de>
# @copyright 2020 Universität Hamburg
# @license   http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later

# =====[ Configurations ]===========================================================================

unoconv_path="/usr/local/bin/unoconv"
unoconv_max_time="30s"
unoconv_tmp_dir="/tmp"

unoconv_port_range="2000-2999"
unoconv_max_retry=5


# =====[ Script ]===================================================================================

# Loop through arguments to eliminate "--user-profile"
argument_list=()
for argument in "${@}"; do
    if [[ "${argument}" != "--user-profile="* ]]
    then
        argument_list+=("${argument}")
    fi
done

# Create temporary directory
if ! user_dir="$(mktemp --tmpdir="${unoconv_tmp_dir}" --directory unoconv.XXXXXXXX)"
then
    exit 254
fi

# Try n-times to get a available port in given range
lock_counter=0
for retry in $(seq 1 "${unoconv_max_retry}")
do
    # Try random port in range
    unoconv_port="$(shuf -i "${unoconv_port_range}" -n 1)"

    # Lock file/port
    exec {lock_fd}> "${unoconv_tmp_dir}/unoconv.${unoconv_port}.lock" || continue
    flock --nonblock --exclusive "${lock_fd}" || { ((lock_counter++));  continue; }

    # Run unoconv with timeout and a temporary user profile
    timeout "${unoconv_max_time}" "${unoconv_path}" --user-profile="${user_dir}" "${argument_list[@]}"
done

# Clean up
rm -rf "${user_dir}"

# Set statuscode in case of lock failure
if [[ "${lock_counter}" -eq "${unoconv_max_retry}" ]]
then
    exit 255
fi
