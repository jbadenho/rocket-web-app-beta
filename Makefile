TODAYS_DATE_TIME:=$(shell date +'%y.%m.%d_%H.%M.%S')
ENV_TAG_DATE_CHANGE:=$(shell sed -i -e 's/\(TAG_DATE=\)\(.*\)/\1${TODAYS_DATE_TIME}/' .env)
CONTAINER_ROCKET_EXIST:=$(shell sudo docker container ls -a | grep 'rocket-web-app-beta:latest' | cut -d ' ' -f4)
IMAGE_ROCKET_EXIST:=$(shell sudo docker image ls -a | grep 'rocket-web-app-beta[ ^]' | cut -d ' ' -f1)

# help: @ Lists available make tasks
help:
	@egrep -oh '[0-9a-zA-Z_\.\-]+:.*?@ .*' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# clean: @ Cleans the build output directories
.PHONY: clean
clean: docker-clean

# container-clean: @ Cleans containers used by images
container-clean:
	@if [ -n "$(CONTAINER_ROCKET_EXIST)" ]; \
	then \
	sudo docker container rm $(shell sudo docker container stop $(shell sudo docker ps -a -q --filter ancestor=rocket-web-app-beta)); \
	fi

# build-clean: @ Cleans production output (to build/site)
build-clean: container-clean
	@if [ -n "$(IMAGE_ROCKET_EXIST)" ]; \
	then \
	sudo docker image rm rocket-web-app-beta; \
	fi

# build: @ Builds production output (to build/site)
build: build-clean
	@sudo docker-compose up -d

# preview: @ Shows results of change
preview:
	@sudo docker-compose up

# docker-clean: @ Docker volume/image/container/system clean (use with caution)  
docker-clean:
	@sudo docker container prune -f
	@sudo docker volume prune -f
	@sudo docker image prune -a -f
	@sudo docker system prune -a -f

# docker-residue: @ Shows all docker pulled/created
docker-residue:
	@sudo docker container ls -a
	@sudo docker volume ls
	@sudo docker image ls -a

# shell: @ Opens bash shell in choosen container
shell:
	@sudo docker run -it rocket-web-app-beta

# git: @ Performs git commands to add work from current branch to GitHub
git: COMMENT ?=
git:
	@git add .
	@git commit -m "$(COMMENT)"
	@git push origin $(shell git branch --show-current)