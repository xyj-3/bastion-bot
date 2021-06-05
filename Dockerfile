ARG NODE_VERSION=14-buster
FROM node:${NODE_VERSION} as base
WORKDIR /app
COPY package*.json yarn.lock ./
RUN yarn --prod

FROM base as dev
RUN yarn

FROM dev as build
COPY . .
RUN yarn build

FROM base
ARG BOT_REVISION
LABEL org.opencontainers.image.title Eris-TypeScript Discord bot template
LABEL org.opencontainers.image.authors bastionbotdev@gmail.com
LABEL org.opencontainers.image.source https://github.com/kevinlul/eris-bot-template.git
LABEL org.opencontainers.image.licenses AGPL-3.0-or-later
LABEL org.opencontainers.image.revision ${BOT_REVISION}
ENV BOT_REVISION=${BOT_REVISION}
WORKDIR /app
COPY COPYING .
COPY --from=build /app/dist .
USER node
CMD ["node", "--enable-source-maps", "--unhandled-rejections=strict", "."]