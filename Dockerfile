FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/
COPY ./conf/ /usr/local/apache2/conf/

RUN apt-get update -y \
 && apt-get install -y \
            curl \
 && apt-get autoclean -y \
 && apt-get clean all 

# Mandatory Labels
LABEL PROJECT=geneweb
LABEL MAINTAINER="slash5toaster@gmail.com"
LABEL NAME=geneweb
LABEL VERSION=httpd-24
LABEL GENERATE_SINGULARITY_IMAGE=false
LABEL PRODUCTION=false

#### End of File, if this is missing the file has been truncated
