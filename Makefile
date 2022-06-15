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


.PHONY: git
git:
	@echo "Configuring git."
	@echo $(shell basename $${PWD})


.PHONY: git-commit-all
git-commit-all:
	git add .
	git commit -m "auto-commit"
	git push
	git status

.PHONY: bump
bump: venv ## PART= (bump the release version - deduced automatically from commit messages since the last tag unless PART is explicitly provided)
	. $(_VENV_ACTIVATE) && \
		cz bump --files-only --yes $(if $(PART),--increment=$(PART))

.PHONY: commit
commit: venv ## (prompt for interactive conventional commit)
	. $(_VENV_ACTIVATE) && \
		cz commit