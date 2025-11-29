FROM node:22
RUN apt-get update -y \ 
    # install apt-utils
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install -y curl \ 
    && apt-get install -y iputils-ping \ 
    && apt-get install -y net-tools \
    && apt-get install -y traceroute \
    && apt-get install -y telnet \
    # remove cache
    && apt-get clean

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ENTRYPOINT ["npm", "start"]