#!/bin/bash

# Fetches the netdata repo and builds the documentation HTML site
# With this script, we can ensure that any changes to the markdown files of this repo
# that are included in the main docs will not break the HTML generation.
# The script is called by netlify whenever something changes to the repo

set -e

echo "Cloning the netdata repo"
#git clone https://github.com/netdata/netdata.git netdata
git clone https://github.com/cakrit/netdata.git -b localization netdata

cd netdata

echo "Calling the netdata docs/generator/buildhtml.sh"
./docs/generator/buildhtml.sh

echo "HTML Documentation produced under netdata/generator/build"




