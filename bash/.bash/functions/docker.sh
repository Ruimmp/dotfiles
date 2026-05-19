function docker() {
  if [[ "$1" == "nuke" ]]; then
    docker-nuke
  elif [[ "$1" == "redo" ]]; then
    shift
    docker-redo "$@"
  else
    command docker "$@"
  fi
}

function docker-nuke() {
  echo "Nuclear option initiated: Cleaning up EVERYTHING Docker..."

  if [[ -n "$(command docker ps -aq 2>/dev/null)" ]]; then
    echo "Stopping and removing all containers..."
    command docker ps -aq | xargs -r docker rm -f
  fi

  if [[ -n "$(command docker images -aq 2>/dev/null)" ]]; then
    echo "Removing all images..."
    command docker images -aq | xargs -r docker rmi -f
  fi

  if [[ -n "$(command docker volume ls -q 2>/dev/null)" ]]; then
    echo "Removing all volumes..."
    command docker volume ls -q | xargs -r docker volume rm -f
  fi

  local networks=$(command docker network ls -q 2>/dev/null | grep -vE "bridge|host|none")
  if [[ -n "$networks" ]]; then
    echo "Removing all custom networks..."
    echo "$networks" | xargs -r docker network rm
  fi

  echo "Cleaning up build cache and remaining metadata..."
  command docker builder prune -a -f 2>/dev/null || true
  command docker system prune -a --volumes -f

  echo "Docker environment has been completely nuked."
}

function docker-redo() {
  echo "Redoing Docker Compose environment..."

  if [[ ! -f "docker-compose.yml" ]] && [[ ! -f "docker-compose.yaml" ]]; then
    echo "Error: No docker-compose.yml or docker-compose.yaml found."
    return 1
  fi

  command docker compose down -v --remove-orphans
  command docker compose up -d "$@"

  echo "Docker Compose environment has been redone."
}
