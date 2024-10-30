FROM node:12-alpine

RUN apk add --update bash

# Setting env vars

ENV SITE_NAME=

ENV LINK_LENGTH=6
ENV REDIS_DB=0
ENV DISALLOW_REGISTRATION=false
ENV DISALLOW_ANONYMOUS_LINKS=false
ENV USER_LIMIT_PER_DAY=50
ENV NON_USER_COOLDOWN=0
ENV DEFAULT_MAX_STATS_PER_LINK=5000
ENV CUSTOM_DOMAIN_USE_HTTPS=false
ENV JWT_SECRET=securekey
ENV ADMIN_EMAILS=""
ENV RECAPTCHA_SITE_KEY=""
ENV RECAPTCHA_SECRET_KEY=""
ENV GOOGLE_SAFE_BROWSING_KEY=""
ENV MAIL_HOST=""
ENV MAIL_PORT=0
ENV MAIL_SECURE=true
ENV MAIL_USER=""
ENV MAIL_FROM=""
ENV MAIL_PASSWORD=""
ENV REPORT_EMAIL=""
ENV CONTACT_EMAIL=""

# Setting working directory. 
WORKDIR /usr/src/app

# Installing dependencies
COPY package*.json ./
RUN npm install

# Copying source files
COPY . .

# Give permission to run script
RUN chmod +x ./wait-for-it.sh

# Build files
RUN npm run build

EXPOSE 3000

# Running the app
CMD [ "npm", "start" ]