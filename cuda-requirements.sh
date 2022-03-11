#!/bin/bash
apt install wget -y

# Add NVIDIA package repositories
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
apt-get update

wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/nvidia-machine-learning-repo-ubuntu2004_1.0.0-1_amd64.deb

apt install -y ./nvidia-machine-learning-repo-ubuntu2004_1.0.0-1_amd64.deb
apt-get update

wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnvinfer7_7.2.3-1+cuda11.1_amd64.deb
apt install -y ./libnvinfer7_7.2.3-1+cuda11.1_amd64.deb
apt-get update

# Install development and runtime libraries (~4GB)
apt-get install --no-install-recommends -y \
    cuda-11-6 \
    libcudnn8=8.3.2.44-1+cuda11.5  \
    libcudnn8-dev=8.3.2.44-1+cuda11.5

# Reboot. Check that GPUs are visible using the command: nvidia-smi

# Install TensorRT. Requires that libcudnn8 is installed above.
#apt-get install -y --no-install-recommends libnvinfer7=7.2.3-1+cuda11.1 \
#    libnvinfer-dev=7.2.3-1+cuda11.1 \
#    libnvinfer-plugin7=7.2.3-1+cuda11.1


rm ./nvidia-machine-learning-repo*
rm ./libnvinfer7*

