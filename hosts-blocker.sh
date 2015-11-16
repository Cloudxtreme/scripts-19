#!/bin/bash
#
# Copyright (C) 2015 Mario Sanchez Prada.
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

HOSTS_FILE="/etc/hosts"
BACKUP_HOSTS_FILE="${HOSTS_FILE}-$(date +%Y%m%d-%H:%M:%S).bckp"
BLOCKED_SUFFIX="#### BLOCKED SITE"
BLOCKED_SITES="facebook.com twitter.com"

function quit ()
{
    local EXIT_CODE=0

    # return exit code, if present
    [ $# -gt 0 ] && EXIT_CODE=$1

    # show descriptive message, if present
    [ $# -gt 1 ] && echo "$2"

    exit ${EXIT_CODE}
}

function show_usage ()
{
    echo "Usage: hosts-blocker.sh <block|unblock>"
}

function unblock_sites ()
{
    TMP_FILE=$(mktemp)
    grep -v "${BLOCKED_SUFFIX}" ${HOSTS_FILE} > ${TMP_FILE}
    sudo cp ${TMP_FILE} ${HOSTS_FILE}
    rm -f ${TMP_FILE}
}

function block_sites ()
{
    # Unblock first to avoid duplication
    unblock_sites

    # Now block them
    for site in ${BLOCKED_SITES}; do
        echo "127.0.0.1    $site ${BLOCKED_SUFFIX}" >> "${HOSTS_FILE}"
        echo "127.0.0.1    www.$site ${BLOCKED_SUFFIX}" >> "${HOSTS_FILE}"
    done
}

# MAIN BODY

if [ "$(whoami)" != "root" ]; then
    quit 1 "You must be root to run this script"
fi

if [ $# -eq 0 ] || [ "${1}" != "block" ] && [ "${1}" != "unblock" ]; then
    show_usage
    exit 1
fi

echo "Backing up current ${HOSTS_FILE} into ${BACKUP_HOSTS_FILE}..."
sudo cp ${HOSTS_FILE} ${BACKUP_HOSTS_FILE}

if [ "${1}" == "block" ]; then
    echo "Blocking sites..."
    block_sites
elif [ "${1}" == "unblock" ]; then
    echo "Unblocking sites..."
    unblock_sites
else
    show_usage
    exit 1
fi

echo "Done!"
