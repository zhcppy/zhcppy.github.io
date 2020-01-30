FROM nginx:latest

COPY ./nginx.conf /etc/nginx/nginx.conf
ADD ./server-cert.pem /etc/nginx/
ADD ./server-key.pem /etc/nginx/

ENTRYPOINT nginx -g "daemon off;"
