FROM node:18-alpine

WORKDIR /app
COPY entrypoint.sh /entrypoint.sh

RUN npm install -g appcenter-cli \
    && apk update \
    && apk add git 

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]