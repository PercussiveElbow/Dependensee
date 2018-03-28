FROM httpd:2.4
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /usr/local/apache2/conf/httpd.conf 
COPY . /usr/local/apache2/htdocs/
