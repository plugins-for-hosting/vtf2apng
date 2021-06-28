# syntax=docker/dockerfile:1
FROM python:3.9-slim-buster

VOLUME [ "/image-in/", "/image-out/" ] 

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get -y install wine wine32 cron && \
	rm -rf /var/lib/apt/lists/* && \
	python -m pip install --no-cache-dir pillow

RUN mkdir -p /app/temp/

WORKDIR /app/

COPY sprays.py ./
COPY tier0.dll ./
COPY vtf2tga.exe ./
COPY FileSystem_Stdio.dll ./
COPY vstdlib.dll ./

COPY spray-cron /etc/cron.d/spray-cron
RUN chmod +x /etc/cron.d/spray-cron 

CMD [ "cron", "-f" ]