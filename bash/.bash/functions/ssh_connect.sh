ssh_connect() {
  if [[ "$1" == "" ]]; then
    if [[ ! -f ~/.ssh/config ]]; then
      echo "SSH config file not found at ~/.ssh/config"
      return 1
    fi

    local BLUE='\033[0;34m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local CYAN='\033[0;36m'
    local RESET='\033[0m'
    local BOLD='\033[1m'

    echo ""
    echo -e "${BLUE}${BOLD}╔═══════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}${BOLD}║            AVAILABLE SSH CONNECTIONS           ║${RESET}"
    echo -e "${BLUE}${BOLD}╚═══════════════════════════════════════════════╝${RESET}"
    echo ""

    local hosts=()
    local hosts_file

    hosts_file=$(mktemp)

    awk '
    BEGIN { host=""; hostname=""; user=""; }
    /^Host / {
      if (host != "" && host != "*") {
        printf("%s|%s|%s\n", host, (hostname != "" ? hostname : "N/A"), (user != "" ? user : "default"));
      }
      host=$2;
      hostname="";
      user="";
    }
    /^[[:space:]]*Hostname / { hostname=$2; }
    /^[[:space:]]*User / { user=$2; }
    END {
      if (host != "" && host != "*") {
        printf("%s|%s|%s\n", host, (hostname != "" ? hostname : "N/A"), (user != "" ? user : "default"));
      }
    }
    ' ~/.ssh/config >"$hosts_file"

    hosts=()

    while IFS= read -r line; do
      hosts+=("$line")
    done <"$hosts_file"

    rm -f "$hosts_file"

    if [[ ${#hosts[@]} -eq 0 ]]; then
      echo -e "${YELLOW}No hosts found in SSH config.${RESET}"
      return 1
    fi

    local max_host_len=4
    local max_hostname_len=8

    for host_info in "${hosts[@]}"; do
      IFS='|' read -r host hostname user <<<"$host_info"
      (( ${#host} > max_host_len )) && max_host_len=${#host}
      (( ${#hostname} > max_hostname_len )) && max_hostname_len=${#hostname}
    done

    max_host_len=$((max_host_len + 2))
    max_hostname_len=$((max_hostname_len + 2))

    local header_format="${CYAN}%-3s${RESET} ${BOLD}%-${max_host_len}s${RESET} %-${max_hostname_len}s %s\n"
    local line_format="${GREEN}%-3s${RESET} ${YELLOW}%-${max_host_len}s${RESET} ${CYAN}%-${max_hostname_len}s${RESET} %s\n"

    printf "$header_format" "No." "Host" "Hostname" "User"

    echo -e "${BLUE}$(printf '═%.0s' {1..60})${RESET}"

    declare -a display_hosts

    local i=1

    for host_info in "${hosts[@]}"; do
      IFS='|' read -r host hostname user <<<"$host_info"
      display_hosts[$i]="$host_info"
      printf "$line_format" "$i)" "$host" "$hostname" "$user"
      ((i++))
    done

    echo ""
    echo -e "${BLUE}════════════════════════════════════════════════════════${RESET}"
    echo -e -n "${BOLD}Select a host number to connect to (or press Enter to cancel): ${RESET}"

    read selection

    if [[ -n "$selection" ]] && [[ "$selection" =~ ^[0-9]+$ ]] && ((selection >= 1)) && ((selection <= ${#hosts[@]})); then
      local selected_host="${display_hosts[$selection]}"

      IFS='|' read -r host hostname user <<<"$selected_host"

      echo ""
      echo -e "${BLUE}╔═══════════════════════════════════════════════╗${RESET}"
      echo -e "${BLUE}║${RESET} ${BOLD}Connecting to:${RESET} ${YELLOW}$host${RESET} as ${CYAN}$user${RESET}"
      echo -e "${BLUE}║${RESET} ${BOLD}Hostname:${RESET}     ${CYAN}$hostname${RESET}"
      echo -e "${BLUE}╚═══════════════════════════════════════════════╝${RESET}"

      command ssh "$host"
    elif [[ -n "$selection" ]]; then
      echo -e "${YELLOW}Invalid selection.${RESET}"
    fi
  else
    command ssh "$@"
  fi
}
