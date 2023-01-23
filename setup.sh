#!/usr/bin/env bash

set -e

# for multi-user setup of nix systemd is required
# here we enable systemd for wsl
if [[ (! -f "/etc/wsl.conf") ||  -z $(grep -F 'systemd=true' /etc/wsl.conf) ]]; then

	cat <<EOF | sudo tee /etc/wsl.conf
[boot]
systemd=true
EOF

	# restart is required after this command
	wsl.exe --shutdown
fi


# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

cat <<EOF >> "$HOME/.bashrc"
if [[ -f "\$HOME/.config/rc.sh" ]]; then
    source "\$HOME/.config/rc.sh"
fi
EOF
# new lines to /etc/bashrc and /etc/bash.bashrc were added

git clone git@github.com:dtsykunov/configs.git "$HOME/.config"

pushd "$HOME/.config"
nix profile install \
                .#fzf \
                .#neovim \
                .#ripgrep

