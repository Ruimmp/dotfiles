setup_venv() {
    local target_dir="${1:-.}"

    if [ -z "$target_dir" ] || [ ! -d "$target_dir" ]; then
        echo "[setup_venv] Invalid or non-existent directory." >&2
        return 1
    fi

    cd "$target_dir" || return 1

    if [ -d ".venv" ]; then
        echo "[setup_venv] Using existing .venv in '$(pwd)'"
    else
        local py_cmd=""

        for candidate in python3 python py python.exe; do
            if command -v "$candidate" >/dev/null 2>&1; then
                py_cmd="$candidate"
                break
            fi
        done

        if [ -z "$py_cmd" ]; then
            echo "[setup_venv] No Python interpreter found." >&2
            return 4
        fi

        echo "[setup_venv] Creating .venv using '$py_cmd'..."
        "$py_cmd" -m venv .venv || return 5
    fi

    local activate_script=""

    if [ -f ".venv/Scripts/activate" ]; then
        activate_script=".venv/Scripts/activate"
    elif [ -f ".venv/bin/activate" ]; then
        activate_script=".venv/bin/activate"
    fi

    if [ -z "$activate_script" ]; then
        echo "[setup_venv] Activation script not found." >&2
        return 6
    fi

    echo "[setup_venv] Activating venv..."

    source "$activate_script" || return 7

    if [ -f "requirements.txt" ]; then
        echo "[setup_venv] Installing requirements..."
        if command -v pip >/dev/null 2>&1; then
            pip install -r requirements.txt || return 8
        else
            echo "[setup_venv] pip not found." >&2
            return 9
        fi
    fi

    echo ""
    echo "[setup_venv] Success — .venv is activated"
    echo "[setup_venv] Python: $(python -V 2>&1)"
    echo ""

    return 0
}

export -f setup_venv
