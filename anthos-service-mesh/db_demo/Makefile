SHELL := /usr/bin/env bash
ROOT := ${CURDIR}

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make build_image       Build the db-demo image.'
	@echo '    make push_image        Push the db-demo image to gcr.'
	@echo '    make create_k8s_sa     Create the K8S service account.'	
	@echo '    make deploy_db_secrets Deploy the DB related K8S secrets.'
	@echo '    make deploy_db_demo    Deploy the db-demo app into GKE.'
	@echo '    make db_demo_ingress   Deploy the db-demo ingress.'	
	@echo


check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

.PHONY: build_image
build_image:
	@$(call check_defined, PROJECT_ID)	
	@$(call check_defined, DB_DEMO_VERSION)
	@docker build -t gcr.io/${PROJECT_ID}/db-demo:${DB_DEMO_VERSION} . -f Dockerfile

.PHONY: push_image
push_image:
	@$(call check_defined, PROJECT_ID)	
	@$(call check_defined, DB_DEMO_VERSION)
	@docker push gcr.io/${PROJECT_ID}/db-demo:${DB_DEMO_VERSION}

.PHONY: create_k8s_sa
create_k8s_sa:
	@./create_k8s_sa.sh


.PHONY: deploy_db_secrets
deploy_db_secrets:
	@$(call check_defined, PROJECT_ID)
	@$(call check_defined, PGPASSWORD_BASE64)
	@kubectl create namespace db-demo --dry-run=client -o yaml | kubectl apply -f -
	@envsubst < db-secrets.yaml | kubectl -n db-demo apply -f -

.PHONY: deploy_db_demo
deploy_db_demo:
	@$(call check_defined, PROJECT_ID)
	@$(call check_defined, DB_DEMO_VERSION)
	@$(call check_defined, PG_CONN_NAME)
	@$(call check_defined, PGDATABASE)	
	@$(call check_defined, PGUSER)
	@kubectl create namespace db-demo --dry-run=client -o yaml | kubectl apply -f -
	@envsubst < db-demo.yaml | kubectl -n db-demo apply -f -


.PHONY: db_demo_ingress
db_demo_ingress:
	@$(call check_defined, BASE_DOMAIN)
	@$(call check_defined, APP_SVC_NAME)
	@$(call check_defined, K8S_NS)
	@./create_db_demo_ingress.sh