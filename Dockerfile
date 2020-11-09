FROM gcr.io/google_appengine/nodejs
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl
RUN apt-get install -y iputils-ping
RUN apt-get install -y net-tools
RUN apt-get install -y traceroute
RUN apt-get install -y telnet

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

COPY . .

ENTRYPOINT ["npm", "start"]