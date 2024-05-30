variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "access-key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "secret-key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}