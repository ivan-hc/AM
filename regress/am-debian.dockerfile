## To run this image using podman:
## 1. podman build -t am-debian -f am-debian.dockerfile
## 2. podman run -it --device /dev/fuse --cap-add SYS_ADMIN debian:latest /bin/bash

# Use the official Debian image as a parent image
FROM debian:latest

# Install dependencies and AM
RUN apt update && apt full-upgrade -y && apt install -y sudo wget curl git fuse bsdextrautils file locales unzip
RUN cd && wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL && rm ./INSTALL
RUN cd && git clone https://github.com/ivan-hc/AM AM

# Copy regression folder
COPY ../regress /root/regress

# Setup locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen && update-locale LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8

# Setup env
RUN echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
RUN echo "cd" >> ~/.bashrc

# Done
RUN echo "Container ready!"
CMD ["/bin/bash"]

