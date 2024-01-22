FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install SteamCMD
RUN echo "**** Install SteamCMD ****" \
  && echo steam steam/question select "I AGREE" | debconf-set-selections \
  && echo steam steam/license note '' | debconf-set-selections \
  && dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates locales lib32gcc-s1 libsdl2-2.0-0:i386 steamcmd \
  && ln -s /usr/games/steamcmd /usr/bin/steamcmd \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

ENTRYPOINT ["steamcmd"]
RUN +force_install_dir ./ets2
RUN +login anonymous
RUN +app_update 1948160 validate
RUN +quit
