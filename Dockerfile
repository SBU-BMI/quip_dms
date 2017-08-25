FROM centos:7
MAINTAINER Erich Bremer "erich.bremer@stonybrook.edu"
### turn off selinux
RUN sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
### turn off ipv6
RUN sed -i 's/GRUB_CMDLINE_LINUX="crashkernel=auto rhgb quiet"/GRUB_CMDLINE_LINUX="ipv6.disable=1 crashkernel=auto rhgb quiet"/g' /etc/default/grub
### update OS
RUN yum update -y
RUN yum install -y wget which
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/epel-release.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum install -y php56w php56w-opcache php56w-xml php56w-mcrypt php56w-gd php56w-devel php56w-mysql php56w-intl php56w-mbstring
RUN yum install -y httpd
RUN yum install -y mariadb-server mariadb-client
RUN sed -i 's/;date.timezone =/date.timezone = America\/New_York/g' /etc/php.ini
RUN sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g' /etc/php.ini

# Define working directory.
WORKDIR /data
RUN service mariadb start
RUN mysql -u root -e "create database QuIP"

RUN wget https://getcomposer.org/installer
RUN php installer
RUN rm -f installer
RUN mv composer.phar /usr/local/bin/composer
RUN composer require drush/drush
RUN ln -s /data/vendor/drush/drush/drush /usr/local/bin/drush
RUN drush dl drupal-8.3.7
RUN mv drupal-8.3.7 drupal
RUN cd drupal
RUN drush -y si standard --db-url=mysql://root:@localhost/QuIP
RUN drush upwd --password="changelater" "admin"
RUN drush -y pm-enable rest serialization

COPY run.sh /root/run.sh
CMD ["sh", "/root/run.sh"]

