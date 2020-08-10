# PlaneRCNN Docker Image

This Dockerfile helps you create a Docker image for PlaneRCNN (which is kind of tricky to compile).

Make sure to read [Mo Kari's blog](https://blog.mkari.de/posts/reproducible-ml-models-using-docker/), who has a great introduction to reproducible ML models. 

## Build

Make sure that your docker host is running on the NVIDIA runtime when building the project. Have a look in the [Setup section on Mo's blog](https://blog.mkari.de/posts/reproducible-ml-models-using-docker/). 

Go to the project directory and run ```docker build -t planercnn --build-args architecture=sm_37 -f docker/Dockerfile .```. 

## Run

The entrypoint executes evaluate.py in the planercnn Conda environment. 

You can also just enter bash by running ```docker run --runtime nvidia -it --entrypoint /bin/bash planercnn```. Make sure to activate the prepared Conda environment by calling ```source activate planercnn```.
