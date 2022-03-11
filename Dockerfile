# Check: https://hub.docker.com/r/nvidia/cuda/tags
ARG CUDA_VERSION=11.6.0

FROM nvidia/cuda:${CUDA_VERSION}-base-ubuntu20.04

# Fork from Alex Sorokine "https://github.com/sorokine"
MAINTAINER Raphael Jenni

# install Python
ARG _PY_SUFFIX=3
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}


# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip
RUN apt-get install -y zip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

RUN pip --version && pip3 --version && ${PYTHON} --version

RUN ln -s $(which ${PYTHON}) /usr/local/bin/python


RUN mkdir -p /opt/colab

WORKDIR /opt/colab

RUN pip install jupyterlab
RUN pip install jupyter_http_over_ws
RUN pip install ipywidgets
# RUN pip install google-colab not needed anymore

RUN jupyter serverextension enable --py jupyter_http_over_ws && jupyter nbextension enable --py widgetsnbextension

# install task-specific packages
RUN pip install pytorch-pretrained-bert
RUN pip install sklearn
RUN pip install transformers
RUN pip install matplotlib
RUN pip install annoy
RUN pip install tensorflow
RUN pip install tensorflow_datasets
RUN pip install tensorflow_hub


# Fix: https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d
ENV TZ=Europe/Zurich
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Fix: https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
RUN DEBIAN_FRONTEND=noninteractive apt-get install keyboard-configuration

# Cuda Requirments
COPY cuda-requirements.sh /
RUN /cuda-requirements.sh

RUN apt install nvidia-cuda-toolkit -y
RUN apt-get install libcusolver-11-0 # https://github.com/tensorflow/tensorflow/issues/44777

ARG COLAB_PORT=8081
EXPOSE ${COLAB_PORT}
ENV COLAB_PORT ${COLAB_PORT}

CMD jupyter notebook --ServerApp.allow_origin='https://colab.research.google.com' --allow-root --ServerApp.port $COLAB_PORT --ServerApp.port_retries=0 --ServerApp.ip 0.0.0.0

