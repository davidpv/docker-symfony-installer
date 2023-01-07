ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

ARG USER_ID
RUN adduser -u $USER_ID --disabled-password --gecos "" appuser

COPY default.conf /etc/nginx/conf.d/
