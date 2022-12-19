SHELL := /usr/bin/env bash
ROOT := ${CURDIR}

.PHONY: help
help:
	@echo 'Usage:'
	@echo '    make enable_apis                Enable Google APIs.'
	@echo '    make configure_iam              Configure IAM permissions.'
	@echo '    make create_kms                 Create KMS secrets.'
	@echo '    make enable_os_login            Enable OS Login for project.'
	@echo '    make create_sa                  Create IAM service accounts.'
	@echo '    make create_network             Create the VPC network.'
	@echo '    make delete_default_network     Delete the default network (a recommended practice).'
	@echo '    make setup_vpc_peering          Set up VPC peering.'
	@echo '    make create_cluster             Create the GKE cluster.'
	@echo '    make ingress_controller         Deploy the Nginx ingress controller.'
	@echo '    make create_dns                 Creat the DNS zone.'	
	@echo '    make create_sql                 Create the Cloud SQL instance.'
	@echo '    make add_sql_dns                Add an DNS record for the Cloud SQL instance.'	
	@echo


.PHONY: enable_apis
enable_apis:
	@./enable_apis.sh

.PHONY: configure_iam
configure_iam:
	@./configure_iam.sh

.PHONY: create_kms
create_kms:
	@./create_kms.sh

.PHONY: enable_os_login
enable_os_login:
	@gcloud compute project-info add-metadata --metadata enable-os-login=TRUE --project ${PROJECT_ID}
	@gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE --project ${PROJECT_ID}

.PHONY: create_sa
create_sa:
	@./create_app_sa.sh
	@./create_node_sa.sh

.PHONY: create_network
create_network:
	@./create_network.sh && ./update_subnet_config.sh && ./create_nat.sh && ./create_vpc_connect.sh

.PHONY: delete_default_network
delete_default_network:
	@echo "IMPORTANT NOTE:"
	@echo "It's a recommended practice to delete the default network and create your own ones as necessary."
	@echo "Make sure this is really what you want!!!"	
	@echo
	@read -p "Press any key to proceed. Ctrl-C to exit."
	@read -p "Press any key to proceed. Ctrl-C to exit."
	@echo
	@./delete_default_network.sh

.PHONY: setup_vpc_peering
setup_vpc_peering:
	@./setup_vpc_peering.sh

.PHONY: create_cluster
create_cluster: enable_os_login
	@GKE_NODES_MAX=3 ./create_gke_cluster.sh

.PHONY: ingress_controller
ingress_controller:
	@echo "IMPORTANT NOTE:"
	@echo "You may need to enter your admin password to install the tools."	
	@echo
	@read -p "Press any key to proceed. Ctrl-C to exit."
	@echo
	@./create_ingress_controller.sh

.PHONY: create_dns
create_dns:
	@./create_dns.sh

.PHONY: create_sql
create_sql:
	@./create_sql_instance.sh

.PHONY: add_sql_dns
add_sql_dns:
	@RECORD_PREFIX=${DB_DNS_RECORD_PREFIX} ./add_sql_dns_record.sh
