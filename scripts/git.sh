#!/usr/bin/env bash

# Install the latest git
add-apt-repository -y ppa:git-core/ppa
apt-get update -yqq
apt-get install -yqq git

# Add git autocompletion
if [ ! -e /etc/bash_completion.d/ ]; then
  mkdir /etc/bash_completion.d/
fi

curl --insecure --location --silent https://github.com/git/git/raw/master/contrib/completion/git-completion.bash | sudo tee /etc/bash_completion.d/git.sh

tee -a /etc/bashrc << EOF

# Git Autocompletion
source /etc/bash_completion.d/git.sh
EOF