FROM hhvm/hhvm:3.15.3

RUN \
  add-apt-repository ppa:nginx/stable && \
  apt-get -qq update && \
  apt-get -y install nginx-light curl unzip supervisor  && \
  apt-get -y -qq install sendmail

# Configure configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install Wordpress
RUN \
  mkdir -p /var/www && \
  curl https://wordpress.org/latest.zip -o /var/www/latest.zip && \
  cd /var/www && unzip latest.zip && \
  mv /var/www/wordpress /var/www/public

# Create wp-config.php
COPY wp-config.php /var/www/public/wp-config.php

# Add salts to wp-config.php
RUN curl https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/public/wp-config.php

# Copy themes and plugins
COPY wp-content/themes/* /var/www/public/wp-content/themes
COPY wp-content/plugins/* /var/www/public/wp-content/plugins

# Expose ports.
EXPOSE 3000

# Define default command
CMD ["/usr/bin/supervisord"]
