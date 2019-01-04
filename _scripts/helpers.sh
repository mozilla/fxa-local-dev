# Helper methods for working with git, npm, docker, and rust projects.

function update_git_branch() {
  git checkout $1 && git pull origin $1
}

function select_git_branch() {
  branch=$1
  if [ -z $branch ]; then
    branch="master"
  fi
}

function revert_npm_lock_files() {
  git checkout -- npm-shrinkwrap.json 2> /dev/null || true
  git checkout -- package-lock.json 2> /dev/null || true
}

function update_node_repo() {
  echo "Updating $1 with branch $branch"
  select_git_branch $2
  (cd $1 && revert_npm_lock_files && update_git_branch $branch && npm ci && cd .. && echo "$1 updated") || echo "$1 update failed"
}

function update_rust_repo() {
  select_git_branch $2
  echo "Updating $1 with branch $branch to create $3"
  (cd $1 && update_git_branch $branch && cargo build --bin $3 && cd .. && echo "$1 updated") || echo "$1 update failed"
}

function update_docker_image() {
  docker pull $1 || echo "$1 update failed"
}