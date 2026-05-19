__BASH_DIR="$HOME/.bash"

_source_dir() {
    local dir="$1"
    [ -d "$dir" ] || return 0
    for f in "$dir"/*.sh; do
        [ -e "$f" ] || continue
        source "$f"
    done
}

# Loader sequence
eval "$(oh-my-posh init bash --config ~/.oh-my-posh/themes/ruimmp.omp.json)"
_source_dir "$__BASH_DIR/settings"
_source_dir "$__BASH_DIR/functions"
source "$__BASH_DIR/aliases.sh"

unset -f _source_dir
unset __BASH_DIR
