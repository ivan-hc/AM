## To run this image using podman:
## 1. podman build -t am-arch -f am-arch.dockerfile
## 2. podman run -it --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL --tmpfs /opt --tmpfs /root/.local/share/applications am-arch:latest

# Use the official Arch image as a parent image
FROM archlinux:latest

# Install dependencies and AM
RUN pacman-key --init && pacman -Sy && pacman -Su --noconfirm sudo wget curl less git glibc fuse3 file unzip xz
RUN cd && wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL && rm ./INSTALL

# Copy regression folder
RUN cd && git clone --depth 1 https://github.com/ivan-hc/AM && mv AM/regress . && rm -rf AM

# Setup locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen && echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Setup AM with safe defaults
RUN printf "y\n\n" | am --user && am --system && am --disable-notifications

# Setup env
RUN echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
RUN echo "export PATH=$PATH:/root/.local/bin" >> ~/.bashrc
RUN echo "echo AM-Arch testing container started" >> ~/.bashrc
WORKDIR /root/regress
CMD ["/bin/bash"]
