FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-devel

# pass in your architecture (see http://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/)
ARG architecture=sm_37

WORKDIR /app

RUN apt-get -y update && apt-get -y install \
        libglib2.0-0 \
        libsm6 \
        libxrender-dev \
        libxext6 \
        unzip \
        wget \
        nano 

RUN nvidia-smi

RUN pip install --upgrade pip

COPY requirements.txt requirements.txt

RUN conda update -n base -c defaults conda
RUN conda create --name planercnn python=3.6 anaconda

# we need to install pytorch 0.4.0 for the NMS compilation to work correctly, 
# we will later upgrade to pytorch 0.4.1
RUN /bin/bash -c "source activate planercnn && \
    conda install pip && \
    pip install -r requirements.txt && \
    conda install -y pytorch=0.4.0"

# compile nms
WORKDIR /app
COPY nms /app/nms
WORKDIR /app/nms/src/cuda
RUN nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch=$architecture

WORKDIR /app/nms
RUN /bin/bash -c "source activate planercnn && conda install -y pytorch=0.4.1"
RUN /bin/bash -c "source activate planercnn && python build.py"

# compile roi_align
COPY roialign /app/roialign
WORKDIR /app/roialign/roi_align/src/cuda
RUN nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch=$architecture

WORKDIR /app/roialign/roi_align
RUN /bin/bash -c "source activate planercnn && python build.py"

# download pre-trained model
WORKDIR /app
RUN wget -q -O checkpoint.zip https://www.dropbox.com/s/yjcg6s57n581sk0/checkpoint.zip?dl=1 && unzip -d checkpoint checkpoint.zip

ENV PYTHONUNBUFFERED=.

# Finally copy all files over
COPY . . 

ENTRYPOINT ["conda", "run", "-n", "planercnn", "python", "evaluate.py"]
