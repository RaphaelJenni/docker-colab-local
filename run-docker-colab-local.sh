#!/bin/bash

# Install nvidia-docker
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit
# Use: distribution=ubuntu20.04 \ or other version from https://nvidia.github.io/nvidia-docker/

docker run \
  --runtime=nvidia \
  -it --rm -p 8081:8081 \
  --memory=16G \
  docker-colab-local
