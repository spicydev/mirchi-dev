# FROM node:latest AS builder
# RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
# WORKDIR /home/node/app
# COPY package*.json ./
# USER node
# RUN npm install
# COPY --chown=node:node . .
# RUN npm run build

FROM node:latest AS builder
RUN mkdir -p /opt/app
WORKDIR /opt/app
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

FROM lipanski/docker-static-website:latest
COPY --from=builder /opt/app/build .
EXPOSE 3000
CMD ["/busybox", "httpd", "-f", "-v", "-p", "3000", "-c", "httpd.conf"]