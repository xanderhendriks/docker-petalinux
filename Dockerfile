FROM ubuntu:18.04

MAINTAINER Xander Hendriks <xander.hendriks@nx-solutions.com>

ENV DEBIAN_FRONTEND=noninteractive 

ENV LC_ALL=en_US.UTF-8 
ENV LANG=en_US.UTF-8 
ENV LANGUAGE=en_US.UTF-8 
ENV TZ=Australia/Sydney

# The URL can be determined by downloading the file from the Xilinx website and check the URL in the download manager (Ctrl+J).
# URL is only valid for a couple of hours
ENV URL "https://xilinx-ax-dl.entitlenow.com/dl/ul/2019/10/28/R210258808/petalinux-v2019.2-final-installer.run/ae6040be1d23492eb9c6bf82ffaf21bd/5F1DCBDB"
ENV LINUX_USER xilinx

ARG USER
ARG PASSWORD
ARG EXTERNAL_URL

# Configure and update system
RUN dpkg --add-architecture i386    && \
    apt-get update -y               && \
    apt-get clean all               && \
    apt-get install -y -qq iputils-ping sudo rsync apt-utils x11-utils

# Install curl for downloading petalinux
RUN apt-get install -y -qq curl ca-certificates

# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, 2019.2
RUN apt-get install -y -qq --no-install-recommends \
    gawk gcc make net-tools libncurses5-dev zlib1g-dev \
    libssl-dev wget gcc-4.8 zlib1g:i386 python vim tofrodos \
    iproute2 xvfb  build-essential checkinstall libreadline-gplv2-dev \
    libncursesw5-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev git make net-tools flex bison libselinux1 gnupg diffstat \
    chrpath socat xterm autoconf libtool tar unzip texinfo gcc-multilib \
    libsdl1.2-dev libglib2.0-dev screen pax gzip language-pack-en libtool-bin \
    cpio lib32z1 lsb-release vim-common libgtk2.0-dev libstdc++6:i386 \
    libc6:i386 expect file less

# Setup locale
RUN apt-get install -y locales && \
    dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    echo "export LANG=en_US.UTF-8" >> ~/.bashrc

# bash is PetaLinux recommended shell
RUN ln -fs /bin/bash /bin/sh

# Setup user as Xilinx installer doesn't allow for root install
RUN adduser --disabled-password --gecos "" ${LINUX_USER}
RUN echo "${LINUX_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create installation directory
RUN mkdir -p /opt/petalinux                 && \
    chown -R ${LINUX_USER}:${LINUX_USER} /opt/petalinux

# Change to linux user and home directory
USER ${LINUX_USER}
WORKDIR /home/${LINUX_USER}

RUN echo "source /opt/petalinux/settings.sh" >> ~/.bashrc

COPY noninteractive-install.sh .
RUN sudo chmod +x noninteractive-install.sh

RUN if [[ -n "${EXTERNAL_URL}" ]] ; then curl -fSL -A "Mozilla/4.0" -u -o petalinux-final-installer.run ${EXTERNAL_URL} ;    \
    else curl -fSL -A "Mozilla/4.0" -u --user=${USER}:${PASSWORD} -o petalinux-final-installer.run ${URL} ; fi            && \
    sudo chmod a+x petalinux-final-installer.run

# Using expect to install Petalinux automatically.
RUN ./noninteractive-install.sh           && \
    rm -rf petalinux-final-installer.run  && \
    rm noninteractive-install.sh *log
