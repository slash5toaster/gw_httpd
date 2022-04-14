FROM httpd:2.4

ARG GW_VER=7.0.0 \
    GW_PR=ab6b706e \
    GW_USER=geneweb \
    GW_GROUP=geneweb \
    GW_UID=115 \
    GW_GID=115
ENV GW_ROOT=/opt/geneweb \
    GWD_PORT=2317 \
    GWSETUP_PORT=2316 \
    HTTP_PORT=80 \
    HTTPS_PORT=443

RUN apt-get update -y \
 && apt-get install -y \
            curl \
            git \
            lynx \
            wget \
            unzip \
 && apt-get autoclean -y \
 && apt-get clean all

# make geneweb
WORKDIR /tmp/
# https://github.com/geneweb/geneweb/releases/download/Geneweb-ab6b706e/geneweb-linux-ab6b706e.zip
RUN mkdir -vp ${GW_ROOT} \
 && wget \
      https://github.com/geneweb/geneweb/releases/download/Geneweb-${GW_PR}/geneweb-linux-${GW_PR}.zip \
      -O /tmp/geneweb-linux-${GW_PR}.zip \
 && unzip /tmp/geneweb-linux-${GW_PR}.zip \
 && mv -v /tmp/distribution/* ${GW_ROOT}/ \
 && rm -v /tmp/geneweb-linux-${GW_PR}*

# add content
COPY public-html/ /usr/local/apache2/htdocs/
COPY conf/ /usr/local/apache2/conf/
COPY cgi-bin/ /usr/local/apache2/cgi-bin/

ENV PATH=$PATH:$GW_ROOT/:$GW_ROOT/gw/

WORKDIR /usr/local/apache2

HEALTHCHECK --interval=5m \
            --timeout=3s \
            --start-period=30s \
  CMD curl -s --fail http://localhost:80 -o /dev/null

CMD ["apachectl -t && apachectl start"]

# Mandatory Labels
LABEL PROJECT=geneweb
LABEL MAINTAINER="slash5toaster@gmail.com"
LABEL NAME=geneweb
LABEL VERSION=httpd-24
LABEL GENERATE_SINGULARITY_IMAGE=false
LABEL PRODUCTION=false

#### End of File, if this is missing the file has been truncated
