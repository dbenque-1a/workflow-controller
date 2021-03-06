# Copyright 2015 The Kubernetes Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARTIFACT=workflow-controller

# 0.0 shouldn't clobber any released builds
TAG = 0.0
#PREFIX = gcr.io/google_containers/${ARTIFACT}
PREFIX =  sdminonne/${ARTIFACT}

SOURCES := $(shell find $(SOURCEDIR) ! -name "*_test.go" -name '*.go')

all: build


build: ${ARTIFACT}

${ARTIFACT}: ${SOURCES}
	CGO_ENABLED=0 GOOS=linux godep go build -i -installsuffix cgo -ldflags '-w' -o ${ARTIFACT} ./main.go

container: build
	docker build -t $(PREFIX):$(TAG) .

push: container
	@echo "He we should push..."
	#docker push $(PREFIX):$(TAG)
	#gcloud docker push $(PREFIX):$(TAG)

depend:
	rm -rf Godeps vendor
	godep save

clean:
	rm -f ${ARTIFACT}

.PHONY: build push clean depend
