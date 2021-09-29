[
  {
    "name": "${name}",
    "image": "${aws_ecr_repository}:${tag}",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "testapp-service",
        "awslogs-group": "${name}-log-group"
      }
    },
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "staging"
      },
      {
        "name": "PORT",
        "value": "${port}"
      }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 65536,
        "hardLimit": 65536
      }
    ],
    "mountPoints": [],
    "memory": 900,
    "volumesFrom": []
  }
]