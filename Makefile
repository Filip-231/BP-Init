SHELL := /bin/bash

-include Makefile.base


BRANCH ?= master
LANGUAGE ?= python
DOMAIN ?= github.com

BOILERPLATE_REPO_PATH = git@github.com:Filip-231/Boilerplate.git
BOILERPLATE_REPO_SSH = git@$(DOMAIN):$(BOILERPLATE_REPO_PATH)

_VENV=.venv
_VENV_ACTIVATE = $(_VENV)/bin/activate
_CURRENT_DIR_NAME = $(shell basename $${PWD})


.PHONY: test123
test123:
	@echo "123Updating Makefiles"
	@echo $(shell basename $${PWD})

.PHONY: test3
test3:
	@echo "3Updating Makefiles"
	@echo $(shell basename $${PWD})
