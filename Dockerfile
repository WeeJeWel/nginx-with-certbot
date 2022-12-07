FROM nginx:alpine

# Install Certbot
RUN apk add certbot certbot-nginx

# Add Cronjob
RUN echo "18	0	*	*	*	/usr/bin/certbot renew --quiet" >> /etc/crontabs/root

# Replace default nginx server config
COPY ./assets/default.conf /etc/nginx/conf.d/default.conf

# Run crond (background) and nginx (foreground)
CMD crond && nginx -g "daemon off;"
