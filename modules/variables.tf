variable "name" {
  description = "Name to be used on VPC"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Controls if ipv6 block is generated"
  type        = bool
  default     = true
}

variable "ipv6_prefixes" {
  description = "Assigns IPv6 subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = []
}

variable "dual_subnets" {
  description = "A list of subnets with both ipv4 and ipv6 config"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "ami" {
  description = "AMI type"
  type        = string
  default     = "ami-0e001c9271cf7f3b9" # Ubuntu Server 22.04 us-east-1
}

variable "num_instances" {
  description = "Number of EC2 instances to deploy"
  type        = number
  default     = 2
}