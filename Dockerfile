FROM hhvm/hhvm:3.15.3
RUN add-apt-repository ppa:nginx/stable
RUN apt-get -qq update
RUN apt-get -y install nginx-light curl unzip

# Install wordpress
RUN mkdir -p /var/www
RUN curl https://wordpress.org/latest.zip -o /var/www/latest.zip
RUN cd /var/www && unzip latest.zip
RUN mv /var/www/wordpress /var/www/public

# Add salts to wp-config.php
RUN curl https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/public/wp-config.php

# Expose ports.
EXPOSE 3000

# Define default command.
CMD ["nginx"]
