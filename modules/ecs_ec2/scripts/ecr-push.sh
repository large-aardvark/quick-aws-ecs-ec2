#!/bin/bash -x
# 
# Builds docker containers and pushes them to ECR
#
# $ ./ecr-push.sh 123456789012.dkr.ecr.eu-west-2.amazonaws.com/hello-world latest ./project
#

set -e

repository_url="$1"
tag="$2"
source_path="$3"

region="$(echo "$repository_url" | cut -d. -f4)"
image_name="$(echo "$repository_url" | grep -Po '/\K.*')"

# build docker image
(cd "$source_path" && DOCKER_BUILDKIT=1 docker build -t "$image_name" .)

aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"
docker tag "$image_name":"$tag" "$repository_url":"$tag"
docker push "$repository_url":"$tag"