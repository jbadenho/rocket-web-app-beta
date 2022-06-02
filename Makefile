TODAYS_DATE_TIME:=$(shell date +'%y.%m.%d_%H.%M.%S')
ENV_TAG_DATE_CHANGE:=$(shell sed -i -e 's/\(TAG_DATE=\)\(.*\)/\1${TODAYS_DATE_TIME}/' .env)
CONTAINER_ROCKET_DEV:=$(shell sudo docker container ls -a | grep 'rocket-web-app-beta-dev:latest' | cut -d ' ' -f4)
CONTAINER_ROCKET_PROD:=$(shell sudo docker container ls -a | grep 'rocket-web-app-beta-prod:latest' | cut -d ' ' -f4)
IMAGE_ROCKET_DEV:=$(shell sudo docker image ls -a | grep 'rocket-web-app-beta-dev[ ^]' | cut -d ' ' -f1)
IMAGE_ROCKET_PROD:=$(shell sudo docker image ls -a | grep 'rocket-web-app-beta-prod[ ^]' | cut -d ' ' -f1)
IMAGE_UBUNTU:=$(shell sudo docker image ls -a | grep 'rocket-web-app-beta-ubuntu[ ^]' | cut -d ' ' -f1)
CONTAINER_STOP_DEV:=$(shell sudo docker container stop $(shell sudo docker ps -a -q --filter ancestor=rocket-web-app-beta-dev))
CONTAINER_STOP_PROD:=$(shell sudo docker container stop $(shell sudo docker ps -a -q --filter ancestor=rocket-web-app-beta-prod))

# help: @ Lists available make tasks
help:
	@egrep -oh '[0-9a-zA-Z_\.\-]+:.*?@ .*' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# docker-clean: @ Docker volume/image/container/system clean (use with caution)
docker-clean:
	$(info docker-clean...)
	sudo docker container prune -f
	sudo docker volume prune -f
	sudo docker image prune -a -f
	sudo docker system prune -a -f

# clean: @ Cleans the build output directories
clean:
	$(info clean...)
	sudo docker container stop $(shell sudo docker ps -a -q)
	sudo docker container prune -f
	sudo docker volume prune -f
	sudo docker image prune -a -f
	sudo docker system prune -a -f

# container-clean: @ Cleans containers used by images
.SILENT: container-check
container-check:
	$(info container-check...)
	if [ -n "$(CONTAINER_ROCKET_DEV)" ] && [ "$(TARGET_ENV)" = "DEV" ]; \
		then \
			sudo docker container rm -f $(CONTAINER_STOP_DEV); \
	fi
	if [ -n "$(CONTAINER_ROCKET_PROD)" ] && [ "$(TARGET_ENV)" = "PROD" ]; \
		then \
			sudo docker container rm -f $(CONTAINER_STOP_PROD); \
	fi

# build-clean: @ Cleans production output (to build/site)
.SILENT: build-check
build-check: container-check
	$(info build-check...)
	if [ -n "$(IMAGE_ROCKET_DEV)" ] && [ "$(TARGET_ENV)" = "DEV" ]; \
		then \
			sudo docker image rm rocket-web-app-beta-dev; \
	fi
	if [ -n "$(IMAGE_ROCKET_PROD)" ] && [ "$(TARGET_ENV)" = "PROD" ]; \
		then \
			sudo docker image rm rocket-web-app-beta-prod; \
	fi

# init: @ Create the core image
.SILENT: init
init: build-check
	$(info init...)
	if [ "$(IMAGE_UBUNTU)" != "rocket-web-app-beta-ubuntu" ]; \
		then \
			sudo docker-compose build; \
	fi

# build: @ Builds production output (to build/site)
.SILENT: build
build: TARGET_ENV ?= DEV
build: init
	$(info build...)
	if [ "$(TARGET_ENV)" = "DEV" ]; \
		then \
			sudo docker-compose --profile dev up -d; \
			echo "http://0.0.0.0:8080 for dev...";\
	fi
	if [ "$(TARGET_ENV)" = "PROD" ]; \
		then \
			sudo docker-compose --profile prod up -d; \
			echo "http://0.0.0.0:8080 for prod..."; \
	fi

# preview: @ Shows results of change
preview: TARGET_ENV ?= DEV
preview: build
	$(info preview...)
	if [ -n "$(TARGET_ENV)" ]; \
		then \
			sudo docker-compose --profile prod up; \
		else \
			sudo docker-compose --profile dev up;
	fi

# deploy: @ Deploys web app to server
deploy: build
	$(info deploy...)
	sudo docker image rm rocket-web-app-beta-ubuntu

# docker-residue: @ Shows all docker pulled/created
docker-residue:
	$(info docker-residue...)
	sudo docker container ls -a
	sudo docker volume ls
	sudo docker image ls -a

# shell: @ Opens bash shell in choosen container
shell:
	$(info shell...)
	sudo docker run -it rocket-web-app-beta

# git: @ Performs git commands to add work from current branch to GitHub
git: COMMENT ?=
git:
	$(info git...)
	git add .
	git commit -m "$(COMMENT)"
	git push origin $(shell git branch --show-current)