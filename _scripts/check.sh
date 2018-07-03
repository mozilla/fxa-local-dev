#!/bin/bash -e
if [[ $(which docker) && $(docker --version) ]]; then
  echo "Docker Found"
else
    os="$(uname -a | cut -f 1 -d ' ')"
    if [ "$os" = "Darwin" ]; then
      echo "Please install docker to continue installation"
      exit 1
    elif [ "$os" = "Linux" ]; then
      sudo apt-get install docker-ce
      sudo groupadd docker
      sudo gpasswd -a $USER docker
      sudo service docker restart
    fi
fi
