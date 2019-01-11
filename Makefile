default: docker_build

DOCKER_IMAGE ?= michaljirman/jenkins-jnlp-slave
DOCKER_TAG ?= v0.4

docker_build:
	@docker build \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	# Push to DockerHub
	@docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

docker_login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
