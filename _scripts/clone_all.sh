#!/bin/bash

set -e

declare -A origins
declare -A options
declare -A branches


# This could be less copy-pasta, but this loop is meant
# to allos us to have all clones at the right branch ASAP.

##
## ORIGINS
##
origins["fxa-content-server"]="https://github.com/mozilla/fxa-content-server.git"
origins["fxa-auth-server"]="https://github.com/mozilla/fxa-auth-server.git"
origins["browserid-verifier"]="https://github.com/vladikoff/browserid-verifier.git"

origins["fxa-oauth-server"]="https://github.com/mozilla/fxa-oauth-server.git"
origins["fxa-oauth-console"]="https://github.com/mozilla/fxa-oauth-console.git"

origins["fxa-profile-server"]="https://github.com/mozilla/fxa-profile-server.git"

origins["123done"]="https://github.com/mozilla/123done.git"

origins["loop-server"]="https://github.com/mozilla-services/loop-server.git"

origins["syncserver"]="https://github.com/mozilla-services/syncserver.git"


##
## SWITCHES
##
options["fxa-content-server"]="--quiet"
options["fxa-auth-server"]="--quiet"
options["browserid-verifier"]="--quiet"

options["fxa-oauth-server"]="--quiet"
options["fxa-oauth-console"]="--quiet"

options["fxa-profile-server"]="--quiet"

options["123done"]="--quiet"

options["loop-server"]="--quiet"

options["syncserver"]="--quiet"


##
## BRANCHES
##
branches["fxa-content-server"]="master"
branches["fxa-auth-server"]="master"
branches["browserid-verifier"]="http"

branches["fxa-oauth-server"]="master"
branches["fxa-oauth-console"]="master"

branches["fxa-profile-server"]="master"

branches["123done"]="oauth"

branches["loop-server"]="master"

branches["syncserver"]="master"


##
## Find what's the HEAD of the repo
##
git_head(){
  echo $(git symbolic-ref HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null) | sed "s#refs/heads/##"
}
# Order is remote, branch
git_count(){
  echo `git rev-list $2...$1/$2 --count`
}

##
## Putting it all together
##
for key in ${!origins[@]}; do
    if [ ! -d "${key}/.git" ]; then
      echo " * Cloning into ${key}"
      git clone -b ${branches[${key}]} ${options[${key}]} ${origins[${key}]} ${key}
    else
      cd ${key}
      echo "Repo ${key} cloned, update with remote:"
      GIT_REMOTE=`git remote show`
      GIT_BRANCH=`git_head`
      if [[ `git symbolic-ref HEAD 2> /dev/null` == "refs"* ]]; then
        COUNT=`git_count $GIT_REMOTE $GIT_BRANCH`
        echo "   - target: ${GIT_REMOTE}/${GIT_BRANCH}"
        echo "   - changes: ${COUNT}"
        if [[ $COUNT ==  1 ]]; then
            git fetch --all
            git reset --soft ${GIT_REMOTE}/${GIT_BRANCH}
            if [[ $? == 1 ]]; then
                MSG="Has new refs upstream but cannot apply them due to dirty workspace . Did nothing."
            else
                MSG="Remote had new refs and had been updated."
            fi
        else
            MSG="Remote ref unchanged. Nothing else to do."
        fi
      else
          MSG="Detached HEAD, cannot go further."
      fi
      cd ../
      echo "   - result: ${MSG}"
      echo ""
    fi
done

exit 0
