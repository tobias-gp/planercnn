##### CUDA & TORCH #####
FROM pytorch/pytorch:nightly-devel-cuda9.2-cudnn7

WORKDIR /app

##### OPENCV2 DEPENDENCIES #####
RUN apt-get -y update && apt-get -y install \
        libglib2.0-0 \
        libsm6 \
        libxrender-dev \
        libxext6 

##### PYTHON PACKAGE DEPENDENCIES #####
RUN pip install --upgrade pip

COPY requirements.txt requirements.txt

RUN conda update -n base -c defaults conda
RUN conda create --name planercnn python=3.6 anaconda

# we need to install pytorch 0.4.0 for the build scripts to work
RUN /bin/bash -c "source activate planercnn && \
    conda install pip && \
    pip install -r requirements.txt && \
    conda install -y pytorch=0.4.0"

# finally compile the stuff
WORKDIR /app/nms/src/cuda
RUN nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=sm_70

WORKDIR /app/nms

# now upgrading to 0.4.1
RUN /bin/bash -c "source activate planercnn && conda install -y pytorch=0.4.1"

RUN /bin/bash -c "source activate planercnn && python build.py"

WORKDIR /app/roialign/roi_align/src/cuda
RUN nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=sm_70

WORKDIR /app/roialign/roi_align
RUN /bin/bash -c "source activate planercnn && python build.py"


ENV PYTHONUNBUFFERED=.

WORKDIR /app
COPY . .



#ENTRYPOINT [ "bash", "run.sh" ]
