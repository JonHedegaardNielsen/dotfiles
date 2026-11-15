set SCRIPTS $HOME/dotfiles/scripts/
if status is-interactive
    set XDG_CONFIG_HOME ~/.config
    fish_hybrid_key_bindings
    starship init fish | source
    alias ls='eza --icons always'
    abbr pac 'sudo pacman -S'
    abbr ga 'git add .'
    abbr gc 'git commit -m "'
    abbr gp 'git push'
    abbr gP 'git pull'
    export EDITOR='nvim'
end
