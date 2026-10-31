# DRS mobile — developer shortcuts. Melos is the source of truth for
# per-package commands; this file adds API-client regeneration.

FLUTTER       ?= flutter
OAG_VERSION   ?= 7.26.0
OAG_JAR       := .tools/openapi-generator-cli-$(OAG_VERSION).jar
BACKEND_DIR   ?= ../drs-backend
# Spec used by api-gen. Defaults to the hand-derived mobile subset; point it at
# the full export once `make api-spec` has produced one.
SPEC          ?= openapi/drs-core.openapi.yaml
FULL_SPEC     := openapi/drs-backend.openapi.json

.PHONY: help bootstrap gen analyze test format api-spec api-gen api-check

help: ## List targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-12s %s\n", $$1, $$2}'

bootstrap: ## Resolve the pub workspace
	dart pub global activate melos
	melos bootstrap

gen: ## Run build_runner in every package that uses it
	melos run gen

analyze: ## flutter analyze across the workspace (must be zero issues)
	melos run analyze

test: ## Run every package's tests
	melos run test

format: ## Check formatting of hand-written code
	melos run format

$(OAG_JAR):
	mkdir -p .tools
	curl -sSfL -o $@ https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$(OAG_VERSION)/openapi-generator-cli-$(OAG_VERSION).jar

api-spec: ## Export the full OpenAPI spec from a local drs-backend checkout (BACKEND_DIR=...)
	@test -d $(BACKEND_DIR)/app || (echo "drs-backend not found at $(BACKEND_DIR)"; exit 1)
	cd $(BACKEND_DIR) && uv run python -c "import json; from app.main import app; print(json.dumps(app.openapi(), indent=1))" > $(CURDIR)/$(FULL_SPEC)
	@echo "Wrote $(FULL_SPEC). Regenerate with: make api-gen SPEC=$(FULL_SPEC)"

api-gen: $(OAG_JAR) ## Regenerate packages/drs_api from SPEC (dart-dio, json_serializable)
	java -jar $(OAG_JAR) generate -c openapi/generator-config.yaml -i $(SPEC)
	cd packages/drs_api && dart run build_runner build
	cd packages/drs_api && $(FLUTTER) analyze --no-pub . && dart test

api-check: $(OAG_JAR) ## Validate SPEC
	java -jar $(OAG_JAR) validate -i $(SPEC)
