export EDITOR=vim

set -o vi

if [[ -d "$HOME/.nix-profile" ]]; then
    for completion in "$(find "$HOME/.nix-profile/share/bash-completion/completions/" -type f)"; do
        source "$completion"
    done

    if [[ -d "$HOME/.nix-profile/share/fzf" ]]; then
        source "$HOME/.nix-profile/share/fzf/key-bindings.bash"
        source "$HOME/.nix-profile/share/fzf/completion.bash"
    fi
fi
