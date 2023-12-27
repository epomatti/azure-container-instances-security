# Azure Container Registry - Security features

Start by creating the `.auto.tfvars` from the template:

```sh
cp config/template.tfvars .auto.tfvars
```

Create the first batch of resources:

```sh
terraform init
terraform apply -auto-approve
```

The container image must exist in order to deploy the CI.

Once the resources are created, build and push the application image to the ACR:

```sh
cd app

az acr build --registry crchokolatte --image app:latest --file Dockerfile.amd64 .
```

Once the image is pushed, set the config to create the CI and the AGW:

```terraform
create_containers = true
```

Create the remaining resources:

```sh
terraform apply -auto-approve
```
