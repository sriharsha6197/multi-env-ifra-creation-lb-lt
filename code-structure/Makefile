dev:
	rm -rf ./terraform
	terraform init --backend-config=dev-env/state.tfvars
	terraform apply --auto-approve --var-file=dev-env/input.tfvars
dev-destroy:
	terraform init --backend-config=dev-env/state.tfvars
	terraform destroy --auto-approve -var-file=dev-env/input.tfvars