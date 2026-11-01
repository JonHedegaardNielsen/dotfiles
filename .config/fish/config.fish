if status is-interactive
    set XDG_CONFIG_HOME ~/.config
    fish_hybrid_key_bindings
    starship init fish | source
    alias ls='eza --icons always'
    abbr pac 'sudo pacman -S'
    export EDITOR='nvim'
end
