SHELL := /usr/bin/env bash
ROOT := ${CURDIR}

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make namespaces         Create the sample app namespaces.'
	@echo '    make deployments        Create the sample app deployments.'
	@echo '    make services           Create the sample app services.'
	@echo '    make app_ingress        Deploy the app ingress.'
	@echo '    make add_custom_headers Deploy custom HTTP headers.'
	@echo


.PHONY: namespaces
namespaces:
	@kubectl apply -f namespaces
	@kubectl get namespaces --show-labels

.PHONY: deployments
deployments:
	@kubectl apply -f deployments

.PHONY: services
services:
	@kubectl apply -f services

.PHONY: app_ingress
app_ingress:
	@./create_app_ingress.sh

.PHONY: add_custom_headers
add_custom_headers:
	@./add_custom_headers.sh