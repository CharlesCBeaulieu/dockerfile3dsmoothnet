# Use the official image as a parent image
FROM nvidia/cuda:11.5.2-runtime-ubuntu20.04

# Set Timezone
ENV TZ=America/Montreal
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the working directory in the container
WORKDIR /app

# Update the system and install Python3, pip, git and sudo
RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev && \
    apt-get install -y git && \
    apt-get install -y sudo

# Check python & pip version
RUN python3 --version
RUN pip3 --version

RUN git clone https://github.com/CharlesCBeaulieu/3DSmoothNet.git
WORKDIR /app/3DSmoothNet

# install pcl
# for clone pcl-1.8.1
# git clone --branch pcl-1.8.1 https://github.com/PointCloudLibrary/pcl.git pcl-trunk 
RUN git clone https://github.com/PointCloudLibrary/pcl.git pcl-trunk
RUN ln -s pcl-trunk pcl
RUN cd pcl

RUN pip3 install --no-cache-dir -r requirements.txt


# Install prerequisites
RUN sudo apt-get install -y g++
RUN sudo apt-get install -y cmake cmake-gui
RUN sudo apt-get install -y doxygen
RUN sudo apt-get install -y mpi-default-dev openmpi-bin openmpi-common
RUN sudo apt-get install -y libflann1.9 
RUN sudo apt-get install -y libflann-dev
RUN sudo apt-get install -y libeigen3-dev
RUN sudo apt-get install -y libboost-all-dev
RUN sudo apt-get install -y libvtk6-dev 
RUN sudo apt-get install -y libvtk6.3-qt 
# RUN sudo apt-get install -y libvtk6.2-qt
#sudo apt-get install libvtk5.10-qt4 libvtk5.10 libvtk5-dev  # I'm not sure if this is necessary.
RUN sudo apt-get install -y 'libqhull*'
RUN sudo apt-get install -y libusb-dev
RUN sudo apt-get install -y libgtest-dev
RUN sudo apt-get install -y git-core freeglut3-dev pkg-config
RUN sudo apt-get install -y build-essential libxmu-dev libxi-dev
RUN sudo apt-get install -y libusb-1.0-0-dev graphviz mono-complete
RUN sudo apt-get install -y qt5-default 
RUN sudo apt-get install -y openjdk-11-jdk 
RUN sudo apt-get install -y openjdk-11-jre
RUN sudo apt-get install -y phonon4qt5-backend-gstreamer
RUN sudo apt-get install -y phonon4qt5-backend-vlc
RUN sudo apt-get install -y libopenni-dev libopenni2-dev
RUN sudo apt-get install -y libboost-filesystem-dev

# install pcl
RUN sudo apt-get install -y libpcl-dev

# Compile and install PCL
RUN cd pcl
RUN mkdir release
RUN cd release
RUN cmake -DCMAKE_BUILD_TYPE=None -DBUILD_GPU=OFF -DBUILD_apps=ON -DBUILD_examples=ON pcl
RUN make -j 8
RUN sudo make install

# compile and install 3DSmoothNet
WORKDIR /app/3DSmoothNet
RUN mkdir build
WORKDIR /app/3DSmoothNet/build
RUN ls
RUN cmake -S .. -B /app/3DSmoothNet/build
RUN make -j 8
#RUN sudo make install

CMD ["/bin/bash"]
