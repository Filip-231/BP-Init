SHELL := /bin/bash

-include Makefile.base
-include Makefile.specific

BRANCH ?= master
LANGUAGE ?= python
DOMAIN ?= github.com
PART ?= #PATCH #MINOR MAJOR
_PROJECT ?=
_USER ?= #will be prepopulated in Makefile.specific

_BOLD := $(shell tput -T ansi bold)
_COLS := $(shell tput -T ansi cols)
_DEFAULT := $(shell tput -T ansi sgr0)
_ITALICS := $(shell tput -T ansi sitm)
_BLUE := $(shell tput -T ansi setaf 4)
_CYAN := $(shell tput -T ansi setaf 6)
_GREEN := $(shell tput -T ansi setaf 2)
_MAGENTA := $(shell tput -T ansi setaf 5)
_RED := $(shell tput -T ansi setaf 1)
_YELLOW := $(shell tput -T ansi setaf 3)

.PHONY: test123
test123:
	@echo "test12345"
	@echo git@github.com:Filip-231/$(_PROJECT).git
#	@echo $(shell basename $${PWD})

.PHONY: git
git: ## _PROJECT=project _USER=user reset git, specify new project and git user
	@echo "Configuring git."
	touch Makefile.specific
	echo _PROJECT=$(_PROJECT) >> Makefile.specific && echo _USER=$(_USER) >> Makefile.specific
	git remote rm origin
	git remote add origin git@github.com:$(_USER)/$(_PROJECT).git
	git push --set-upstream origin master


.PHONY: bump
bump: venv ## PART= bump the release version - deduced automatically from commit messages since the last tag unless PART is explicitly provided
	. $(_VENV_ACTIVATE) && \
		cz bump --files-only --yes $(if $(PART),--increment=$(PART))


.PHONY: all
all: ## commit and push all changes
	git add .
	git commit -m "auto-commit" --no-verify
	git push
	git status


.PHONY: commit
commit: venv ## make interactive conventional commit
	. $(_VENV_ACTIVATE) && \
		cz commit



.PHONY: help
help: ## display this help message
	$(info Please use $(_BOLD)make $(_DEFAULT)$(_ITALICS)$(_CYAN)target$(_DEFAULT) where \
	$(_ITALICS)$(_CYAN)target$(_DEFAULT) is one of:)
	@grep --no-filename "^[a-zA-Z]" $(MAKEFILE_LIST) | \
		sort | \
		awk -F ":.*?## " 'NF==2 {printf "$(_CYAN)%-20s$(_DEFAULT)%s\n", $$1, $$2}'
