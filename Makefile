SHELL := /bin/bash

-include Makefile.base
-include Makefile.specific

BRANCH ?= master
LANGUAGE ?= python
DOMAIN ?= github.com

BOILERPLATE_REPO_PATH = git@github.com:Filip-231/Boilerplate.git
BOILERPLATE_REPO_SSH = git@$(DOMAIN):$(BOILERPLATE_REPO_PATH)

_VENV=.venv
_VENV_ACTIVATE = $(_VENV)/bin/activate
_CURRENT_DIR_NAME = $(shell basename $${PWD})
_PROJECT?=

.PHONY: test123
test123:
	@echo "test123"
	@echo git@github.com:Filip-231/$(_PROJECT).git
#	@echo $(shell basename $${PWD})



.PHONY: git
git:
	@echo "Configuring git."
	touch Makefile.specific
	echo _PROJECT=$(_PROJECT) >> Makefile.specific && echo _USER=$(_USER) >> Makefile.specific
	git remote rm origin
	git remote add origin git@github.com:$(_USER)/$(_PROJECT).git
	git push origin master


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