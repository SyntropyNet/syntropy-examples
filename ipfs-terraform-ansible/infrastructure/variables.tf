variable "ssh_public_key_file" {
  type        = string
  description = "Path to SSH public key" // stored in terraform.tfvars
}

variable "ec2_keypair_name" {
  type        = string
  description = "Name of EC2 keypair name" // stored in terraform.tfvars
}

variable "ec2_image_id" {
  type        = string
  description = "ID of EC2 Ubuntu AMI" // stored in terraform.tfvars
}
