## To run this image using podman:
## 1. podman build -t am-ubuntu -f am-ubuntu.dockerfile
## 2. podman run -it --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL --tmpfs /opt --tmpfs /root/.local/share/applications am-ubuntu:latest

# Use the official Ubuntu image as a parent image
FROM ubuntu:latest

# Install dependencies and AM
RUN apt update && apt full-upgrade -y && apt install -y sudo wget curl git fuse3 bsdextrautils file locales unzip xz-utils
RUN cd && wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL && rm ./INSTALL

# Copy regression folder
RUN cd && git clone --depth 1 https://github.com/ivan-hc/AM && mv AM/regress . && rm -rf AM

# Setup locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen && update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Setup AM with safe defaults
RUN printf "y\n\n" | am --user && am --system && am --disable-notifications

# Setup env
RUN echo "export PATH=$PATH:/root/.local/bin" >> ~/.bashrc
RUN echo "echo \"AM-Ubuntu testing container started\"" >> ~/.bashrc
WORKDIR /root/regress
CMD ["/bin/bash"]
