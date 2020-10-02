# Files for OCP Install on existing VPC


## Contents

"corpsetup" - contains the terraform for creating an existing VPC. This simulates and existing setup that we want to add into
"ocpNets" - contains the terraform for creating the new subnets and required helpers

### Setup

Checkout the code

```
cd corpsetup
terraform init
terraform plan
terraform apply
```

### Creating the new OCP subnets

1. edit ocpNets/variables.tf and update the following variables:
   * vpc_id with the corporate VPC id from setup
   * aws_internet_gateway_id with the corporate internet gateway id from setup
   * aws_nat_gateway_id with the corporate nat gateway from setup
2. run `terraform plan` and validate the changes we will be making
3. run `terraform apply` 

## Install OpenShift IPI on existing VPC

We will now follow the instructions [here](https://docs.openshift.com/container-platform/4.5/installing/installing_aws/installing-aws-vpc.html). Update the install-config.yaml file updating the 




### CLEANUP

Remember to clean up your account when you are done:

```
cd ocpNets
terraform destroy
cd ../corpsetup
terraform destroy
```


## References

https://nickcharlton.net/posts/terraform-aws-vpc.html
https://github.com/nickcharlton/terraform-aws-vpc
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html