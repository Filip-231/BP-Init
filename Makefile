SHELL := /bin/bash

-include .env
-include Makefile.configure
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

.PHONY: test-paths
test-paths:
	@echo "Is this right?"
	@echo git@github.com:$(_USER)/$(_PROJECT).git
	@echo "Current working dir: "$(_CURRENT_DIR_NAME)


.PHONY: git
git: ## _PROJECT=project _USER=user reset git, specify new project and git user
	@echo "Configuring git."
	@echo "Project: $(_PROJECT) User: $(_USER)"
	touch Makefile.specific
	echo _PROJECT=$(_PROJECT) >> .env && echo _USER=$(_USER) >> .env
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
	git commit -m "feat: auto-commit" --no-verify
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


.PHONY: clean
clean:: ## clean up temp and trash files
	find . -type f -name "*.py[cdo]" -delete
	find . -type d -name "__pycache__" -delete
	rm -rf .coverage .mypy_cache .pytest_cache *.egg-info build dist public
	sudo docker-compose down --remove-orphans
	yes | sudo docker system prune --volumes


.PHONY: test
test:: venv ## ALLURE=True run tests
	echo "Executing pytest"
	@. "$(_VENV_ACTIVATE)" && python -m pytest -p no:allure_pytest_bdd --alluredir=public/allure-results --cov --cov-report=term-missing \
			--cov-report=xml:public/coverage.xml \
			--pdb tests/
	if [ "$(ALLURE)" ]; then \
			allure generate --clean --report-dir public/allure-report public/allure-results; \
	fi



.PHONY: test-report
test-report:: test ## show allure test report
	echo "Opening allure report."; \
	allure open "public/allure-report"


.PHONY: docs
docs:: venv ## construct documentations
	. "$(_VENV_ACTIVATE)" && \
		sphinx-build -a -b html -E docs/source public


.PHONY: changelog
changelog: venv ## UNRELEASED= update the changelog incrementally. UNRELEASED is the name of the current, as yet unreleased, version)
	@. $(_VENV_ACTIVATE) && \
		cz changelog --incremental --unreleased-version=$(UNRELEASED)
		#make changelog UNRELEASED=$(make get-version)


.PHONY: get-version
get-version: ## prints the current version
	@. $(_VENV_ACTIVATE) && \
		cz version --project


.PHONY: format
format:: venv ## format code
	. "$(_VENV_ACTIVATE)" && \
		isort . && black .


.PHONY: lint
lint:: venv ## check all code styling
	. "$(_VENV_ACTIVATE)" && \
		prospector


.PHONY: clean
clean:: ## clean up cache and temp files
	find . -type f -name "*.py[cdo]" -delete
	find . -type d -name "__pycache__" -delete
	rm -rf .coverage .mypy_cache .pytest_cache *.egg-info build dist public
