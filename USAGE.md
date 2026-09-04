Terraform AWS 3-Tier Infrastructure – Usage Guide

This document explains the correct order for creating and destroying the Terraform infrastructure using the Bootstrap S3 backend and environment configurations.

1. Repository Structure
Terraform_AWS_3Tier_Modules/
│
├── bootstrap/
│   └── backend/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   ├── stage/
│   ├── test/
│   └── prod/
│
├── modules/
│   ├── vpc/
│   ├── nat/
│   ├── security-groups/
│   ├── iam/
│   ├── alb/
│   ├── compute/
│   ├── database/
│   └── eks/
│
├── README.md
├── USAGE.md
└── versions.tf

2. First-Time Setup – Bootstrap Backend

The Bootstrap configuration creates the S3 bucket required to store Terraform state.

Terraform cannot use an S3 backend before the S3 bucket exists, so Bootstrap must be executed first.

Step 1 – Go to Bootstrap
cd bootstrap/backend

Step 2 – Initialize Terraform
terraform init

Step 3 – Format Terraform files
terraform fmt

Step 4 – Validate configuration
terraform validate


Expected result:

Success! The configuration is valid.

Step 5 – Review the plan
terraform plan


Check that the S3 backend resources are going to be created.

Step 6 – Create the S3 backend
terraform apply


Confirm with:

yes


After successful execution, the Terraform state S3 bucket will be available for the environment Terraform configurations.

3. Deploy Development Environment

After the Bootstrap S3 bucket has been created, deploy the development environment.

Step 1 – Go to Dev
cd ../../environments/dev


Or, from the repository root:

cd environments/dev

Step 2 – Initialize Terraform
terraform init


This initializes the providers and configures the S3 backend.

If migrating an existing local state to S3 for the first time, use:

terraform init -migrate-state


Confirm the state migration when Terraform asks for confirmation.

Step 3 – Format Terraform files
terraform fmt

Step 4 – Validate configuration
terraform validate

Step 5 – Review infrastructure changes
terraform plan


Review the resources Terraform plans to create.

Step 6 – Create the infrastructure
terraform apply


Confirm with:

yes


Terraform will create the AWS infrastructure, including the configured 3-tier architecture and EKS resources.

4. Normal Workflow After Initial Setup

Once the Bootstrap backend has been created, Bootstrap does NOT need to be executed every time.

For normal development work:

cd environments/dev

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply


Terraform state will be stored in the configured S3 backend.

5. Deploy Other Environments

The same process can be used for other environments.

For example:

cd environments/stage


Then:

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply


For production:

cd environments/prod


Then:

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply


Each environment should use its own S3 backend key so that environment states remain separate.

Example:

S3 Bucket
│
├── dev/terraform.tfstate
├── stage/terraform.tfstate
├── test/terraform.tfstate
└── prod/terraform.tfstate

6. Destroy Infrastructure
Important

Destroy the environment infrastructure first.

For example, for DEV:

cd environments/dev


Run:

terraform destroy


Confirm with:

yes


This destroys the resources managed by the DEV environment.

7. Destroy Bootstrap S3 Backend

Only destroy the Bootstrap backend when you no longer need the Terraform state stored in the S3 bucket.

After the environment infrastructure has been destroyed, go to:

cd ../../bootstrap/backend


Run:

terraform destroy


Confirm with:

yes

8. S3 Bucket Delete Error – BucketNotEmpty

If Bootstrap terraform destroy fails with:

Error: deleting S3 Bucket

BucketNotEmpty: The bucket you tried to delete is not empty.
You must delete all versions in the bucket.


The S3 Console may show:

Objects (0)


but the bucket can still contain old object versions or delete markers because S3 Versioning is enabled.

Step 1 – Check Object Versions
aws s3api list-object-versions \
  --bucket three-tier-terraform-state-519041484052 \
  --region ap-south-1 \
  --query 'Versions[*].[Key,VersionId,IsLatest]' \
  --output table

Step 2 – Check Delete Markers
aws s3api list-object-versions \
  --bucket three-tier-terraform-state-519041484052 \
  --region ap-south-1 \
  --query 'DeleteMarkers[*].[Key,VersionId,IsLatest]' \
  --output table

Step 3 – If Both Commands Show Nothing

Run:

aws s3api list-object-versions \
  --bucket three-tier-terraform-state-519041484052 \
  --region ap-south-1


Review the complete output.

Step 4 – Delete All Object Versions and Delete Markers

If versions or delete markers exist, use:

BUCKET="three-tier-terraform-state-519041484052"

aws s3api list-object-versions \
  --bucket "$BUCKET" \
  --region ap-south-1 \
  --output json \
| jq -r '.Versions[]?, .DeleteMarkers[]? | [.Key, .VersionId] | @tsv' \
| while IFS=$'\t' read -r key version; do
    aws s3api delete-object \
      --bucket "$BUCKET" \
      --key "$key" \
      --version-id "$version" \
      --region ap-south-1
  done


If jq is not installed:

sudo apt install jq -y


After deleting the versions, verify again:

aws s3api list-object-versions \
  --bucket three-tier-terraform-state-519041484052 \
  --region ap-south-1


The bucket should contain no object versions or delete markers.

Step 5 – Delete the S3 Bucket
aws s3api delete-bucket \
  --bucket three-tier-terraform-state-519041484052 \
  --region ap-south-1

9. Recommended Destroy Order

Always follow this order:

1. environments/dev
        ↓
   terraform destroy
        ↓
2. environments/stage/prod/test
        ↓
   terraform destroy
        ↓
3. bootstrap/backend
        ↓
   terraform destroy
        ↓
4. Delete S3 object versions if required
        ↓
5. S3 backend bucket deleted


Do NOT delete the S3 backend bucket before destroying or migrating the environment state that depends on it.

10. Quick Command Reference
Bootstrap
cd bootstrap/backend

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

Dev
cd environments/dev

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

Dev Destroy
cd environments/dev

terraform destroy

Bootstrap Destroy
cd bootstrap/backend

terraform destroy

Check S3 Object Versions
aws s3api list-object-versions \
  --bucket three-tier-terraform-state-519041484052 \
  --region ap-south-1

Important Notes
Bootstrap must be executed before using the S3 backend for the first time.
Bootstrap normally needs to be executed only once.
Do not run terraform destroy on Bootstrap while environment states are still required.
Always run terraform plan before terraform apply.
Keep terraform.tfstate, *.tfplan, and sensitive .tfvars files out of Git.
Keep .tfvars.example files in Git for documenting required variables.
Do not manually modify Terraform state unless absolutely necessary.
Before deleting the S3 backend, make sure the Terraform state is no longer required.
