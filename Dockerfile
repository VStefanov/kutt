FROM node:12.22.12-alpine3.14 AS builder

ENV SITE_NAME="" \
    LINK_LENGTH=6 \
    REDIS_DB=0 \
    DISALLOW_REGISTRATION=false \
    DISALLOW_ANONYMOUS_LINKS=false \
    USER_LIMIT_PER_DAY=50 \
    NON_USER_COOLDOWN=0 \
    DEFAULT_MAX_STATS_PER_LINK=5000 \
    CUSTOM_DOMAIN_USE_HTTPS=false \
    JWT_SECRET=securekey \
    ADMIN_EMAILS="" \
    RECAPTCHA_SITE_KEY="" \
    RECAPTCHA_SECRET_KEY="" \
    GOOGLE_SAFE_BROWSING_KEY="" \
    MAIL_HOST="" \
    MAIL_PORT=0 \
    MAIL_SECURE=true \
    MAIL_USER="" \
    MAIL_FROM="" \
    MAIL_PASSWORD="" \
    REPORT_EMAIL="" \
    CONTACT_EMAIL=""

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN chmod +x ./wait-for-it.sh

RUN npm run build

FROM node:12-alpine3.14 AS runtime

ENV SITE_NAME="" \
    LINK_LENGTH=6 \
    REDIS_DB=0 \
    DISALLOW_REGISTRATION=false \
    DISALLOW_ANONYMOUS_LINKS=false \
    USER_LIMIT_PER_DAY=50 \
    NON_USER_COOLDOWN=0 \
    DEFAULT_MAX_STATS_PER_LINK=5000 \
    CUSTOM_DOMAIN_USE_HTTPS=false \
    JWT_SECRET=securekey \
    ADMIN_EMAILS="" \
    RECAPTCHA_SITE_KEY="" \
    RECAPTCHA_SECRET_KEY="" \
    GOOGLE_SAFE_BROWSING_KEY="" \
    MAIL_HOST="" \
    MAIL_PORT=0 \
    MAIL_SECURE=true \
    MAIL_USER="" \
    MAIL_FROM="" \
    MAIL_PASSWORD="" \
    REPORT_EMAIL="" \
    CONTACT_EMAIL=""

COPY --from=builder /usr/src/app /usr/src/app

WORKDIR /usr/src/app

EXPOSE 3000

CMD ["npm", "start"]
