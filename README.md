# Simple EC2 backed ECS deployment

This module deploys a simple EC2 backed ECS HTTP webapp, with a docker image built from the source folder.

Notes:
- The default vpc is used, as there is no need for private subnets in this simple example.
- This module is compatible with AWS "free tier".
- This module has been tested on WSL2 and Windows.
- The docker image is automatically built and pushed to ECR if the /project folder changes, but the service must be updated via the console.

Requirements:
- Terraform
- AWS CLI
- Docker

Instructions:
- Run AWS configure with with your key/secret. Define your desired region in the providers.tf file.
- In the top level main.tf, define your module (see ecs_ec2 vars file and examples for input). There is an example node.js app deployment available to be uncommented.
- Run `terraform init`, followed by `terraform apply` at the `tf-simple/` folder level (where the modules are instantiated), type `yes` to confirm if you are happy with the resources being created.
- Once successfully applied, run `terraform state show 'module.<my-module-name>.aws_lb.lb'` to find the dns_name of the load balancer. Alternatively, you can find the dns_name by going to the EC2 service console, and clicking on the "load balancers" section.
- Your app should be available at this DNS address.
- Remember to run `terraform destroy` when finished to avoid incurring costs!
