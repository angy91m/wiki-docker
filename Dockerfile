FROM mediawiki:1.43.1
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    php -r "unlink('composer-setup.php');"; \
    composer update --no-dev
RUN apt -y update && apt -y install zip unzip nano ploticus fonts-freefont-ttf; \
    cd extensions; \
    git clone -b REL1_43 https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend; \
    git clone -b REL1_43 https://gerrit.wikimedia.org/r/mediawiki/extensions/PluggableAuth; \
    git clone https://github.com/angy91m/WSOAuth.git; \
    git clone -b REL1_43 https://gerrit.wikimedia.org/r/mediawiki/extensions/timeline; \
    cd timeline; \
    composer install --no-dev; \
    cd ..; \
    git clone -b REL1_43 https://gerrit.wikimedia.org/r/mediawiki/extensions/Elastica; \
    cd Elastica; \
    composer install --no-dev; \
    cd ..; \
    git clone -b REL1_43 https://gerrit.wikimedia.org/r/mediawiki/extensions/CirrusSearch; \
    cd CirrusSearch; \
    composer install --no-dev
RUN mkdir images/timeline && chown -R www-data images && composer update