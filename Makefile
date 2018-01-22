default: build

DOCKER_IMAGE?=jbergstroem/frontend-builder

# fix this later
DOCKER_TAG?=1.0

build:
		@docker build \
			--build-arg VCS_REF=`git rev-parse --short HEAD` \
			--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
			-t $(DOCKER_IMAGE):$(DOCKER_TAG) .