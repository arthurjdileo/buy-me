FROM ubuntu:latest

USER root

RUN apt-get update
RUN apt-get install -y nginx nodejs

RUN rm -v /etc/nginx/nginx.conf

ADD nginx.conf /etc/nginx

ADD site /usr/share/nginx/html
ADD site /var/www/html

RUN echo "daemon off;" >> etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT [ "service", "nginx", "start" ]
