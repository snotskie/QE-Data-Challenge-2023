#!/usr/bin/env sh

# On chromeos, and other setups, when you mount a local working directory
# to a virtual machine that runs your python etc., you might not have
# permission to make symbolic links. Node's NPM uses symbolic links,
# except when installing packages globally. That usually isn't a problem.
# However, we're using python's pip to install Node, to make the setup
# simpler yet portable. This combination of things makes it hard for
# the NODE_PATH to point to the global node_modules directory properly.
# The fix is to set the NODE_PATH to python3 -m nodejs.npm root -g.
# This helper script does that, then runs Node on the given script.
# To use this script, set the shebang/hashbang of your Node script to:
# #!./scripts/helpers/node_launch.sh

env NODE_PATH=$(python3 -m nodejs.npm root -g) python3 -m nodejs $1