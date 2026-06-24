FROM nginx:alpine

LABEL maintainer="Jamie Christian II"
LABEL project="cloud-engineering-portfolio"

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK CMD wget -qO- http://localhost || exit 1
