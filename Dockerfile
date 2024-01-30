FROM gameservermanagers/linuxgsm:latest
LABEL maintainer="LinuxGSM <me@danielgibbs.co.uk>"
ARG SHORTNAME=ets2
ENV GAMESERVER=ets2server

USER server
WORKDIR /app

## Auto install game server requirements
RUN depshortname=$(curl --connect-timeout 10 -s https://raw.githubusercontent.com/GameServerManagers/LinuxGSM/master/lgsm/data/ubuntu-22.04.csv | awk -v shortname="ets2" -F, '$1==shortname {$1=""; print $0}') \
  && if [ -n "${depshortname}" ]; then \
  echo "**** Install ${depshortname} ****" \
  && sudo apt-get update \
  && sudo apt-get install -y ${depshortname} \
  && sudo apt-get -y autoremove \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
  fi

COPY ["/config_files/ets2", "/data/.local/share/Euro Truck Simulator 2"]


HEALTHCHECK --interval=1m --timeout=1m --start-period=2m --retries=1 CMD /app/entrypoint-healthcheck.sh || exit 1

RUN date > /build-time.txt

#EXPOSE 27015/tcp
#EXPOSE 27015/tcp
#EXPOSE 27016/udp
#EXPOSE 27016/udp

#RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null
#RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list
#RUN apt update
#RUN apt install playit -y
#RUN playit setup
#RUN playit

ENTRYPOINT ["/bin/bash", "./entrypoint.sh"] 
