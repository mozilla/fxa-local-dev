#!/bin/bash -e
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
      brew install gmp graphicsmagick
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
    else
      echo "install dependencies to continue:"
      echo "sudo apt-get install build-essential git-core libgmp3-dev graphicsmagick python-virtualenv python-dev"
    fi
fi
