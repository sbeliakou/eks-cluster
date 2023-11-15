.PHONY: help init plan apply destroy kubeconfig
help:  ## Help
	@echo Usage:
	@echo "  make init"
	@echo "  make plan"
	@echo "  make apply"
	@echo "  make kubeconfig"
	@echo "  make destroy"
	@echo
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo

help:

# Just in case if the credential set to wrong target account
check-account:
	@if [ -f account.id ]; then \
		if [ $(shell stat -c '%s' account.id) -eq 12 ]; then \
			aws sts get-caller-identity --query "Account" --output text | grep -f account.id >/dev/null || \
			(echo "Your AWS credentials set not to this account" && exit 1); \
		else \
		  echo "Please define account ID in account.id file"; \
		fi; \
	fi

init: check-account
	terragrunt init -upgrade

plan: # init ## Perform terraform/terragrunt plan with initialization
	terragrunt plan -out=tfplan

apply: init ## Perform terraform/terragrunt apply with auto-approve
	terragrunt apply -auto-approve
	make kubeconfig

kubeconfig: ## Retrieve kubeconfig from EKS cluster created by this terraform/terragrunt stack
	aws eks update-kubeconfig --name $(shell terragrunt output -raw eks_cluster_name)

destroy: check-account ## Destroy the stack provisioned by this terraform/terragrunt code
	@(terragrunt output -raw aws_ecr_docker_registry -compact-warnings | sed -n '/^.*Warnings:/q;p'; echo) | while IFS= read -r line; do \
		if [ -n "$$line" ]; then \
			echo "Cleaning up '$$line' ECR Registry"; \
			echo "Proceed? (yes/no)"; read em; \
			if [[ $$em =~ Yes|yes|Y|y ]]; then \
				aws ecr describe-images --repository-name $$line | jq -r '.imageDetails[].imageDigest' | \
				xargs -rIF aws ecr batch-delete-image --repository-name $$line --image-ids imageDigest=F; \
			fi \
		fi \
	done
	terragrunt destroy