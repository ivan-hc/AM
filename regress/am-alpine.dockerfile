## To run this image using podman:
## 1. podman build --platform linux/x86-64 -t am-alpine -f am-alpine.dockerfile
## 2. podman run -it --platform linux/x86-64 --name am-alpine-test --device /dev/fuse --cap-add SYS_ADMIN --security-opt unmask=ALL --tmpfs /opt --tmpfs /root/.local/share/applications am-alpine:latest

# Use the official Alpine image as a parent image
FROM alpine:latest

# Install dependencies and AM
RUN apk update && apk upgrade && apk add bash grep sudo wget coreutils curl git fuse3 util-linux file unzip xz musl musl-utils musl-locales tzdata libnotify binutils 7zip
RUN cd && wget https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL && rm ./INSTALL

# Copy regression folder
RUN cd && git clone --depth 1 https://github.com/ivan-hc/AM && mv AM/regress . && rm -rf AM

# Setup locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Setup AM with safe defaults
RUN printf "y\n\n" | am --user && am --system && am --disable-notifications

# Setup env
RUN echo "export PATH=$PATH:/root/.local/bin" >> ~/.bashrc
RUN echo "echo \"AM-Alpine (musl) testing container started\"" >> ~/.bashrc
WORKDIR /root/regress
CMD ["/bin/bash"]
