# base
FROM node:17.9.0 AS base

USER node

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./

RUN npm install

COPY . .


# for build

FROM base as builder

USER node

WORKDIR /usr/src/app

RUN npm run build


# for production

FROM node:17.9.0-alpine3.15

USER node

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./

RUN npm install --only=production

COPY --chown=node:node --from=builder /usr/src/app/build ./

EXPOSE 8080

ENTRYPOINT ["node","./index.js"]