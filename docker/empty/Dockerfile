From debian:10-slim
MAINTAINER enrico

# port to expose
ARG PORT

# application folder
ENV APP_DIR /opt/app

# update source  ...cp is due to a flat github
RUN apt-get update && \
	apt-get install -yq git supervisor python3 python3-pip && \
   pip3 install --upgrade pip && \
   pip3 install flask gunicorn google-api-python-client && \
   pip3 install --upgrade oauth2client google-cloud-asset && \ 
   useradd -m -d /home/pythonapp pythonapp && \
   rm -rf ${APP_DIR} && \
   mkdir -p ${APP_DIR} && \
   git clone --single-branch --branch  flskindocker https://github.com/eproj-org/test-exe-Igenius.git ${APP_DIR} && \
   #git clone https://github.com/eproj-org/test-exe-Igenius.git ${APP_DIR} && \
	mkdir -p ${APP_DIR}/web && \
	mkdir -p ${APP_DIR}/conf && \
	mkdir -p ${APP_DIR}/logs && \
   cp ${APP_DIR}/*.py  ${APP_DIR}/web && \
   cp ${APP_DIR}/*.ini  ${APP_DIR}/conf && \
   chown -R pythonapp:pythonapp ${APP_DIR} && \
	rm -rf /var/cache/apt/* && \
#   echo "[include]" > /etc/supervisord.conf && \
   mkdir -p /var/log/supervisord && \
	echo "files = ${APP_DIR}/conf/*.ini" >> /etc/supervisor/supervisord.conf

USER pythonapp

# copy config files
COPY ./app ${APP_DIR}

VOLUME ["${APP_DIR}"]

EXPOSE ${PORT}

USER root

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
