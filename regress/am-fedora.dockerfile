## To run this image using podman:
## 1. podman build --platform linux/x86-64 -t am-fedora -f am-fedora.dockerfile
## 2. podman run -it --platform linux/x86-64 --name am-fedora-test --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL --tmpfs /opt --tmpfs /root/.local/share/applications am-fedora:latest

# Use the official Fedora image as a parent image
FROM fedora:latest

# Install dependencies and AM
RUN dnf upgrade -y && dnf install -y sudo wget curl git fuse3 file glibc-langpack-en unzip xz libnotify binutils p7zip p7zip-plugins which
RUN cd && wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL && rm ./INSTALL

# Copy regression folder
RUN cd && git clone --depth 1 https://github.com/ivan-hc/AM && mv AM/regress . && rm -rf AM

# Setup AM with safe defaults
RUN printf "Y\n\n" | am --user && am --system && am --disable-notifications

# Setup env
RUN echo "export PATH=$PATH:/root/.local/bin" >> ~/.bashrc
RUN echo "echo \"AM-Fedora testing container started\"" >> ~/.bashrc
WORKDIR /root/regress
CMD ["/bin/bash"]
