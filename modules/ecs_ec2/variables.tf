variable "image_tag" {
  type        = string
  description = "Tag for downloaded image"
}

variable "image_port" {
  type        = number
  description = "Port that app in container is running on"
}

variable "app_name" {
  type        = string
  description = "Defines the container name and is used to prefix resources (must be unique)."
}

variable "arch" {
  type        = string
  description = "Architecture of docker container to be deployed."
  default     = "x86_64"
  validation {
    condition     = var.arch == "arm64" || var.arch == "x86_64"
    error_message = "Valid choices are arm64 or x86_64."
  }
}

variable "source_path" {
  type = string
  description = "Docker source path"
  default = "./project"
}