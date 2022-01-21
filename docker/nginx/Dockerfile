ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION}

ARG UID
RUN adduser -u $UID --disabled-password --gecos "" appuser

COPY default.conf /etc/nginx/conf.d/
