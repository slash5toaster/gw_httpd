SHELL := /usr/local/bin/bash

# Docker repository for tagging and publishing
DOCKER_REPO ?= localhost
D2S_VERSION ?= v3.9.4
EXPOSED_PORT ?= 28080
GENEWEB_PORT ?= 2316
GWSETUP_PORT ?= 2317

# Date for log files
LOGDATE := $(shell date +%F-%H%M)

# pull the name from the docker file - these labels *MUST* be set
CONTAINER_PROJECT ?= $(shell grep LABEL Dockerfile | grep PROJECT | cut -d = -f2 | tr -d '"')
CONTAINER_NAME ?= $(shell grep LABEL Dockerfile | grep NAME | cut -d = -f2 | tr -d '"')
CONTAINER_TAG ?= $(shell grep LABEL Dockerfile | grep VERSION | cut -d = -f2| tr -d '"')
CONTAINER_STRING ?= $(CONTAINER_PROJECT)/$(CONTAINER_NAME):$(CONTAINER_TAG)

# HELP
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

envs: ## show the environments
	$(shell echo -e "${CONTAINER_STRING}\n\t${CONTAINER_PROJECT}\n\t${CONTAINER_NAME}\n\t${CONTAINER_TAG}")

# all: ## Building two images Server (JupyterHub) and Client (JupyterLab).
# 	$(MAKE) local
# 	$(MAKE) remote
# 	$(MAKE) singularity

local: ## Build the image locally.
	docker build . \
					-t $(CONTAINER_STRING) \
					--progress plain \
					--label BUILDDATE=$(LOGDATE) 2>&1 \
					| tee source/logs/build-$(CONTAINER_PROJECT)-$(CONTAINER_NAME)_$(CONTAINER_TAG)-$(LOGDATE).log
	docker inspect $(CONTAINER_STRING) > source/logs/inspect-$(CONTAINER_PROJECT)-$(CONTAINER_NAME)_$(CONTAINER_TAG)-$(LOGDATE).log

remote: external-sync ## Push the image to remote.
	$(MAKE) local

singularity: ## Create a singularity version.
	docker run \
	        -v /var/run/docker.sock:/var/run/docker.sock \
					-v $(shell pwd)/source:/output \
					--privileged \
					-t \
					--rm \
					quay.io/singularity/docker2singularity:$(D2S_VERSION) \
					$(CONTAINER_STRING)

shell: ## shell in server image.
	docker run \
	        --rm \
					-it \
					-p $(EXPOSED_PORT):80 \
					-p $(GENEWEB_PORT):$(GENEWEB_PORT) \
					-p $(GWSETUP_PORT):$(GWSETUP_PORT) \
					-e DEBUG=0 \
					-v $(shell pwd):/opt/devel \
					-v $(shell pwd)/public-html/:/usr/local/apache2/htdocs/ \
					-v $(shell pwd)/cgi-bin/:/usr/local/apache2/cgi-bin/ \
					-v $(shell pwd)/bases/:/opt/geneweb/bases/ \
					$(CONTAINER_STRING) bash

publish: ## Push server image to remote
	@echo 'pushing server-$(VERSION) to $(DOCKER_REPO)'
	docker push $(CONTAINER_STRING)

# Commands for extracting information on the running container
GET_IMAGES := docker images ${IMAGE_NAME} --format {{.ID}}
GET_CONTAINER := docker ps -a --filter "name=${CONTAINER_NAME}" --no-trunc
GET_ID := ${GET_CONTAINER} --format {{.ID}}
GET_STATUS := ${GET_CONTAINER} --format {{.Status}} | cut -d " " -f1
