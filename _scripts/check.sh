#!/bin/sh -e
if [[ $(which node) && $(node --version) ]]; then
  node _scripts/check_node_version.js
else
  echo "install node to continue installation"
  echo "https://nodejs.org"
  exit 1
fi

if [[ $(which docker) && $(docker --version) ]]; then
  docker=y
else
  docker=n
fi

os="$(uname -a | cut -f 1 -d ' ')"
if [ "$os" = "Darwin" ]; then
    if [ "$docker" = "n" ]; then
      echo "install docker to continue installation"
      echo "https://docs.docker.com/docker-for-mac/install/"
      exit 1
    fi

    if [[ $(which brew) && $(brew --version) ]]; then
      brew install gmp
      if [[ $(which gm) && $(gm -version) ]]; then
        echo "graphicsmagick is already installed"
      else
        brew install graphicsmagick
      fi
    else
      echo "install homebrew to continue installation"
      echo "https://brew.sh/"
      exit 1
    fi
elif [ "$os" = "Linux" ]; then
    if [ "$docker" = "n" ]; then
      echo "install docker to continue installation using the steps below:"
      echo "sudo apt-get install docker-ce"
      echo "sudo groupadd docker"
      echo "sudo gpasswd -a $USER docker"
      echo "sudo service docker restart"
    fi
fi
