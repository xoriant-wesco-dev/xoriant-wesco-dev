1. Init
terraform.exe init

2. Plan
terraform.exe plan -var-file=tfvars/test/secrets.auto.tfvars -var-file=tfvars/test/terraform.tfvars

3. Apply
terraform.exe apply -auto-approve -var-file=tfvars/test/secrets.auto.tfvars -var-file=tfvars/test/terraform.tfvars

4. Destroy
 terraform.exe destroy -var-file=tfvars/test/secrets.auto.tfvars -var-file=tfvars/test/terraform.tfvars
