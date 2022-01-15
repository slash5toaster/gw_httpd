FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/


# Mandatory Labels
LABEL PROJECT=geneweb
LABEL MAINTAINER="slash5toaster@gmail.com"
LABEL NAME=geneweb
LABEL VERSION=httpd-24
LABEL GENERATE_SINGULARITY_IMAGE=false
LABEL PRODUCTION=false

#### End of File, if this is missing the file has been truncated
