if status is-interactive
    fish_hybrid_key_bindings
    starship init fish | source
    alias ls='eza'
end
