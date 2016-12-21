FROM hhvm/hhvm:3.15.3
RUN add-apt-repository ppa:nginx/stable
RUN apt-get -qq update
RUN apt-get -y install nginx-light curl unzip

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Install wordpress
RUN mkdir -p /var/www
RUN curl https://wordpress.org/latest.zip -o /var/www/latest.zip
RUN cd /var/www && unzip latest.zip
RUN mv /var/www/wordpress /var/www/public

# Create wp-config.php
COPY wp-config.php /var/www/public/wp-config.php

# Add salts to wp-config.php
RUN curl https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/public/wp-config.php

# Copy themes and plugins
COPY wp-content/themes/* /var/www/public/wp-content/themes
COPY wp-content/plugins/* /var/www/public/wp-content/plugins

# Expose ports.
EXPOSE 3000

# Define default command.
CMD ["nginx"]
