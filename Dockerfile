FROM node:6.11-alpine

RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache \
# add "bash" for "[["
		bash

RUN mkdir /ghost

ENV GHOST_VERSION 1.14.0
ENV GHOST_SOURCE /ghost
ENV GHOST_CONTENT /ghost/content

COPY ./ /ghost/
WORKDIR $GHOST_SOURCE

RUN npm install -g knex-migrator --registry=https://registry.npm.taobao.org
RUN npm install "ghost@$GHOST_VERSION" --save
RUN npm install sqlite3 --save

COPY docker-entrypoint.sh /entrypoint.sh

ENV URL=http://localhost:2368
ENV NODE_ENV=production

VOLUME $GHOST_CONTENT

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2368
CMD ["node", "index.js"]
