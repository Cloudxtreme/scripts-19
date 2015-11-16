#!/bin/bash
#
# Converts QEMU raws images to Virtual Box's vdi format
#
# Copyright (C) 2012 Mario Sanchez Prada.
# Authors: Mario Sanchez Prada <mario@mariospr.org>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 (or later)
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

function quit ()
{
    local EXIT_CODE=0

    # return exit code, if present
    [ $# -gt 0 ] && EXIT_CODE=$1

    # show descriptive message, if present
    [ $# -gt 1 ] && echo "" && echo "[ERROR]: ${2}" && echo ""

    exit ${EXIT_CODE}
}

function usage ()
{
    echo "Usage: qemu2vbox <origin file> [<destination file>]"
    echo ""
}

# MAIN BODY

if [ $# -eq 0 ] || [ $# -gt 2 ] || [ "${1}" == "help" ] || [ "${1}" == "usage" ]; then
    # show usage
    usage
    exit 0
fi

# check requirements
which VBoxManage > /dev/null 2>&1 || \
    quit 1 "Command 'VBoxManage' not found. Haven't you installed VirtualBox yet?"

# get paths and names for origin file
ORIGIN_PATH="$1"
if [[ "$1" != /* ]]; then
    # path is relative
    ORIGIN_PATH="$(pwd)/$(dirname $1)/$(basename $1)"
fi
shift 1

# check path and names for (optional) destination file
if [ $# -gt 0 ]; then
    DESTINATION_PATH="$1"

    if [[ "$1" != /* ]]; then
        # path is relative
        DESTINATION_PATH="$(pwd)/$(dirname $1)/$(basename $1)"
    fi
else
    DESTINATION_PATH="${ORIGIN_PATH}.vdi"
fi
shift 1

echo "Converting the QEMU image to Virtual Box's format..."
VBoxManage convertdd "${ORIGIN_PATH}" "${DESTINATION_PATH}" || \
    quit 1 "A problem has ocurred while converting the image"
echo "[OK]: Image converted"
echo

echo "Compacting Virtual Box's image..."
VBoxManage modifyvdi "${DESTINATION_PATH}" compact || \
    quit 1 "A problem has ocurred while compacting the result image"
echo "[OK]: Image compacted"
echo

echo "Process finished!"
echo

exit 0
