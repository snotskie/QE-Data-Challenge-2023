#!/usr/bin/env sh

# Install libraries for data cleaning in Python
python3 -m pip install pandas

# Install and configure Julia 1.8
# Binaries will be placed in ~/.opt/julias
# Symlinks will be placed in ~/.local/bin
# Use this hashbang in julia scripts: #!/usr/bin/env -S ${HOME}/.local/bin/julia-1.8
# Jill edits your .bashrc to add that to your PATH,
# but Mac doesn't look at .bashrc as much as Linux
JILL_INSTALL_DIR=$HOME/.opt/julias
export JILL_INSTALL_DIR
PATH=$HOME/.local/bin:$PATH
export PATH
if ! command -v julia-1.8 &> /dev/null
then
    python3 -m pip install jill
    python3 -m jill install --confirm 1.8
fi
julia-1.8 -e 'using Pkg; Pkg.add(url="https://github.com/snotskie/EpistemicNetworkAnalysis.jl")'
julia-1.8 -e 'using Pkg; Pkg.add(["CSV", "DataFrames", "Plots", "Colors", "Statistics", "HypothesisTests", "JSON"])'

# Install and configure Node.JS
# Node packages will be installed at `python3 -m site --user-site`/nodejs/lib/node_modules
# Since that won't be in the NODE_PATH, easiest fix is to ln that directory here
# However...the linux tools on Chromeos don't allow symbolic links from user content
# pointing at linux content. The workaround is to use the ./scripts/helpers/node_launch.sh
# script to set the NODE_PATH dynamically.
# So, use this hashbang in your node scripts: #!./scripts/helpers/node_launch.sh
python3 -m pip install nodejs-bin
python3 -m nodejs.npm install -g express squirrelly mathjs @marp-team/marp-core

# Make sure certain directories exist
mkdir -p data/raw
mkdir -p data/metadata
mkdir -p data/processed
mkdir -p data/output
mkdir -p public/figs

# Mark that we're done
touch .setup_complete