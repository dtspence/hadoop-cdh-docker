define uc
	$(shell echo '$1' | tr '[:lower:]' '[:upper:]')
endef

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

export NATIVE_VERSION=$(HADOOP_VERSION)-x64

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

names = base datanode historyserver namenode nodemanager resourcemanager test

build: build-native $(patsubst %,build-%,$(names)) ## Builds all images (or specific image)

build-native:
	docker build -t $(NAMESPACE)/hadoop-native:$(NATIVE_VERSION) -f native/Dockerfile \
		--build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
		native

build-%:
	$(eval IMG := $(call uc,$*)_IMAGE_NAME)
	docker build -t $(NAMESPACE)/$(${IMG}):$(VERSION) -f $*/Dockerfile \
		--build-arg VERSION=$(VERSION) \
		--build-arg HADOOP_VERSION=$(HADOOP_VERSION) \
		--build-arg CDH_VERSION=$(CDH_VERSION) \
		$*

push-native:
	docker push $(NAMESPACE)/hadoop-native:$(NATIVE_VERSION)

push-version: $(patsubst %, push-version-%,$(names))  ## Push all images to the repository (or specific image)

push-version-%: 
	$(eval IMG := $(call uc,$*)_IMAGE_NAME)
	docker push $(NAMESPACE)/$(${IMG}):$(VERSION)

push-latest: $(patsubst %, push-latest-%,$(names))  ## Push latest images to the repository (or specific image)

push-latest-%:
	$(eval IMG := $(call uc,$*)_IMAGE_NAME)
	docker tag $(NAMESPACE)/$(${IMG}):$(VERSION) $(NAMESPACE)/$(${IMG}):$(LATEST_VERSION)
	docker push $(NAMESPACE)/$(${IMG}):$(LATEST_VERSION)

clean-images: $(patsubst %,clean-image-%,$(names)) ## Remove all images (or specific image)

clean-image-%: 
	$(eval IMG := $(call uc,$*)_IMAGE_NAME)
	docker rmi $(NAMESPACE)/$(${IMG}):$(VERSION) 2>/dev/null; true

run-tests:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d
	@echo $(docker logs test -f)

version: ## Output the current version
	@echo $(VERSION)
	