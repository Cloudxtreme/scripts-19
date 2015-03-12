#!/bin/bash
#
# Copyright (C) 2009 Mario Sanchez Prada.
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
# This script updates your WebKit local respository in a faster way
# than just using git-svn rebase by fetching changes from the git
# mirror to the associated remote repository first, then updating the
# references in your local branch tracking the SVN repository.

[ $# -lt 3 ] &&
{
  echo "Not enough parameters"
  exit 1
}

mencoder -oac copy -ovc copy -idx -o "$3" "$1" "$2"
