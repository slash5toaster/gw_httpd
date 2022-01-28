FROM httpd:2.4

ARG GW_VER=7.0.0 \
    GW_PR=88536ed4 \
    GW_USER=geneweb \
    GW_GROUP=geneweb \
    GW_UID=115 \
    GW_GID=115
ENV GW_ROOT=/opt/geneweb \
    GWD_PORT=2317 \
    GWSETUP_PORT=2316 \
    HTTP_PORT=80 \
    HTTPS_PORT=443

COPY ./public-html/ /usr/local/apache2/htdocs/
COPY ./conf/ /usr/local/apache2/conf/

RUN apt-get update -y \
 && apt-get install -y \
            curl \
            git \
            wget \
            unzip \
 && apt-get autoclean -y \
 && apt-get clean all 

# make geneweb
WORKDIR /tmp/
RUN mkdir -vp ${GW_ROOT} \
 && wget https://github.com/geneweb/geneweb/releases/download/v${GW_VER}/geneweb-linux-${GW_PR}.zip \
      -O /tmp/geneweb-linux-${GW_PR}.zip
RUN unzip /tmp/geneweb-linux-${GW_PR}.zip \
    && mv -v /tmp/distribution/* ${GW_ROOT}/ \
    && rm -v /tmp/geneweb-linux-${GW_PR}*

WORKDIR /usr/local/apache
HEALTHCHECK --interval=5m \
            --timeout=3s \
            --start-period=30s \
  CMD curl -s --fail http://localhost:80 -o /dev/null
# Mandatory Labels
LABEL PROJECT=geneweb
LABEL MAINTAINER="slash5toaster@gmail.com"
LABEL NAME=geneweb
LABEL VERSION=httpd-24
LABEL GENERATE_SINGULARITY_IMAGE=false
LABEL PRODUCTION=false

#### End of File, if this is missing the file has been truncated
