# Use nginx to serve static HTML files
FROM nginx:alpine

# Copy HTML files to nginx default directory
COPY form.html /usr/share/nginx/html/
COPY results.html /usr/share/nginx/html/

# Create nginx configuration template
RUN echo 'server {' > /etc/nginx/conf.d/default.conf.template && \
    echo '    listen ${PORT};' >> /etc/nginx/conf.d/default.conf.template && \
    echo '    root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf.template && \
    echo '    index form.html;' >> /etc/nginx/conf.d/default.conf.template && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf.template && \
    echo '        try_files $uri $uri/ /form.html;' >> /etc/nginx/conf.d/default.conf.template && \
    echo '    }' >> /etc/nginx/conf.d/default.conf.template && \
    echo '}' >> /etc/nginx/conf.d/default.conf.template

# Create startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf' >> /start.sh && \
    echo 'nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

# Default to port 80 for Docker, but allow Cloud Run to override with PORT=8080
ENV PORT=80
EXPOSE $PORT

# Start nginx with environment variable substitution
CMD ["/start.sh"]
