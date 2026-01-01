#!/bin/sh

# original: https://github.com/stuartleeks/wsl-dev-container-clipboard-dotfiles/blob/3482a39375752d4c314e0380e714b94175468e49/clip/clip.sh
for i in "$@"
do
  case "$i" in
  (-i|--input|-in)
    tee <&0 | socat - tcp:host.docker.internal:8121
    exit 0
    ;;
  esac
done