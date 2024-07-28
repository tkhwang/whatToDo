FROM node:18-alpine as build

WORKDIR /usr/src/app

COPY package.json .
COPY yarn.lock .
COPY packages/models ./packages/models
COPY apps/backend ./apps/backend

RUN yarn install --pure-lockfile --non-interactive

WORKDIR /usr/src/app/packages/models
RUN yarn

WORKDIR /usr/src/app/apps/backend
RUN yarn build

FROM node:18-alpine

WORKDIR /usr/src/app

COPY package.json .
COPY yarn.lock .

COPY --from=build /usr/src/app/packages/models/package.json /usr/src/app/packages/models/package.json
COPY --from=build /usr/src/app/apps/backend/package.json /usr/src/app/apps/backend/package.json
COPY --from=build /usr/src/app/apps/backend/dist /usr/src/app/apps/backend/dist

ENV NODE_ENV production

RUN yarn install --pure-lockfile --non-interactive --production

WORKDIR /usr/src/app/apps/backend

CMD ["yarn", "start:prod"]