#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

#
# Infrastructure Fields
#

variable "infrastructure" {
  description = <<-EOF
Specify the infrastructure information for deploying.

Examples:
```
infrastructure:
  namespace: string, optional
  image_registry: string, optional
  domain_suffix: string, optional
```
EOF
  type = object({
    namespace      = optional(string)
    image_registry = optional(string, "registry-1.docker.io")
    domain_suffix  = optional(string, "cluster.local")
  })
  default = {}
}

#
# Deployment Fields
#

variable "architecture" {
  description = <<-EOF
Specify the deployment architecture, select from standalone or replication.
EOF
  type        = string
  default     = "standalone"
  validation {
    condition     = var.architecture == null || contains(["standalone", "replication"], var.architecture)
    error_message = "Invalid architecture"
  }
}

variable "engine_version" {
  description = <<-EOF
Specify the deployment engine version, select from https://hub.docker.com/r/bitnami/redis/tags.
EOF
  type        = string
  default     = "7.0"
}

variable "password" {
  description = <<-EOF
Specify the account password.
EOF
  type        = string
  default     = null
  validation {
    condition     = var.password == null || can(regex("^[A-Za-z0-9\\!#\\$%\\^&\\*\\(\\)_\\+\\-=]{8,32}", var.password))
    error_message = "Invalid password"
  }
}

variable "resources" {
  description = <<-EOF
Specify the computing resources.

Examples:
```
resources:
  cpu: number, optional
  memory: number, optioanl       # in megabyte
```
EOF
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 0.25
    memory = 256
  }
}

variable "storage" {
  description = <<-EOF
Specify the storage resources.

Examples:
```
storage:                         # convert to empty_dir volume or dynamic volume claim template
  class: string, optional
  size: number, optional         # in megabyte
```
EOF
  type = object({
    class = optional(string)
    size  = optional(number, 20 * 1024)
  })
  default = null
}
