## To run this image using podman:
## 1. podman build --platform linux/x86-64 -t am-debian-old -f am-debian-old.dockerfile
## 2. podman run -it --platform linux/x86-64 --name am-jessie-test --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL --tmpfs /opt --tmpfs /root/.local/share/applications am-debian-old:latest

# Use the official Debian Jessie image as a parent image
FROM debian:jessie

# Install dependencies and AM
# Notes: 7zip not available in Jessie, and GPG warnings is normal, repos are archieved
RUN echo 'deb http://archive.debian.org/debian jessie main contrib non-free' > /etc/apt/sources.list
RUN echo 'deb http://archive.debian.org/debian-security jessie/updates main contrib non-free' >> /etc/apt/sources.list
RUN echo 'Apt::Get::AllowUnauthenticated "true";' > /etc/apt/apt.conf.d/99verify-apt-https
RUN apt update && apt full-upgrade -y && apt install -y sudo wget curl git fuse bsdmainutils file locales unzip xz-utils libterm-readline-gnu-perl libnotify-bin binutils
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
RUN echo "echo \"AM-Debian Jessie (old) testing container started\"" >> ~/.bashrc
WORKDIR /root/regress
CMD ["/bin/bash"]
