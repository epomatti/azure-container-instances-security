# Azure Container Registry - Security features

Deploy Azure Container Instances groups in a VNET.

<img src=".assets/azure-ci.png" width=500/>

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

Connect to the application using the Application Gateway public address.


### YAML deployment

An option to [deploy containers with YAML][1] files is also available.

Example copied from the documentation in the [deploy-aci.yaml](./deploy-aci.yaml) file:

```sh
az group create --name myResourceGroup --location eastus
az container create --resource-group myResourceGroup --file deploy-aci.yaml
```


[1]: https://learn.microsoft.com/en-us/azure/container-instances/container-instances-multi-container-yaml#deploy-the-container-group
