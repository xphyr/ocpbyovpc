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




## References

https://nickcharlton.net/posts/terraform-aws-vpc.html
https://github.com/nickcharlton/terraform-aws-vpc
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html