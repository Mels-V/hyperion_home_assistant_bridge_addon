FROM node:14

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY src/package.json /usr/src/app/
RUN npm install

COPY src /usr/src/app
COPY run.sh /usr/src/app

RUN chmod +x /usr/src/app/run.sh

CMD [ "/usr/src/app/run.sh" ]
