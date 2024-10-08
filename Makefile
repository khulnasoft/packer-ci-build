DISTRIBUTION ?= ubuntu
JQ ?= del(."post-processors"[])
PACKER ?= packer

ifeq ($(DISTRIBUTION), ubuntu)
JSON_FILE = khulnasoft-ubuntu.json
BOX_FILE = khulnasoft-ginkgo-virtualbox-iso.box
else ifeq ($(DISTRIBUTION), ubuntu-next)
JSON_FILE = khulnasoft-ubuntu-next.json
BOX_FILE = khulnasoft-ginkgo-virtualbox-iso-next.box
else ifeq ($(DISTRIBUTION), ubuntu-4-19)
JSON_FILE = khulnasoft-ubuntu-4.19.json
BOX_FILE = khulnasoft-ginkgo-virtualbox-iso-4-19.box
else ifeq ($(DISTRIBUTION), ubuntu-5-4)
JSON_FILE = khulnasoft-ubuntu-5.4.json
BOX_FILE = khulnasoft-ginkgo-virtualbox-iso-5-4.box
else
$(error "Distribution $(DISTRIBUTION) is unsupported")
endif

all: build

build: clean validate
	jq '$(JQ)' $(JSON_FILE) | $(PACKER) build $(ARGS) -

validate:
	jq '$(JQ)' $(JSON_FILE) | $(PACKER) validate -

clean:
	rm -Rf $(BOX_FILE) tmp packer_cache packer-*

install:
	vagrant box add --force khulnasoft/$(DISTRIBUTION) $(BOX_FILE)

.PHONY = build validate clean install
