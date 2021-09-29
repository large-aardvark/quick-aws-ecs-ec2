## Examples - uncomment to test
##

module "simple-ecs-app2" {
  source   = "./modules/ecs_ec2"
  app_name = "myapp"
  image_tag = "latest"
  image_port = 3000
}
