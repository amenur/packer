locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


variable "profile" {
  type        = string
  description = ""
  default     = "aramis"
}

variable "image_name" {
  type        = string
  description = ""
}

variable "project_name" {
  type        = string
  description = ""
}

variable "ami_description" {
  type        = string
  description = ""
}

variable "force_delete_snapshot" {
  type        = bool
  description = ""
  default     = true
}

variable "force_deregister" {
  type        = bool
  description = ""
  default     = true
}

variable "instance_type" {
  type        = string
  description = ""
  default     = "t2.micro"
}

variable "region" {
  type        = string
  description = ""
  default     = "eu-west-1"
}

variable "tags" {
  type        = map(string)
  description = ""
  default = {
    "Project_name" = ""
    "Environment"  = ""
    "Cost_center"  = ""
  }
}

variable "filter_ami_name" {
  type        = string
  description = "(optional)"
  default     = "amzn2-ami-hvm-2.*-x86_64-gp2"
}
variable "root_device" {
  type        = string
  description = "(optional)"
  default     = "ebs"
}

variable "virtualization_type" {
  type        = string
  description = ""
  default     = "hvm"
}

variable "most_recent" {
  type        = bool
  description = ""
  default     = true
}

variable "owners" {
  type        = list(string)
  description = ""
  default     = ["amazon"]
}

variable "ssh_username" {
  type        = string
  description = ""
  default     = "ec2-user"
}

variable "file_destination" {
  type        = string
  description = ""
  default     = "/tmp"
}

variable "file_source" {
  type        = string
  description = ""
  default     = "./files"
}

##############################################################

source "amazon-ebs" "this" {
  profile               = var.profile
  ami_name              = "${var.image_name}-${var.project_name}-aws-${local.timestamp}"
  ami_description       = var.ami_description
  force_delete_snapshot = var.force_delete_snapshot
  force_deregister      = var.force_deregister
  instance_type         = var.instance_type
  region                = var.region
  tags                  = var.tags
  source_ami_filter {
    filters = {
      name                = var.filter_ami_name
      root-device-type    = var.root_device
      virtualization-type = var.virtualization_type
    }
    most_recent = var.most_recent
    owners      = var.owners
  }
  ssh_username = var.ssh_username
}

build {
  sources = [
    "source.amazon-ebs.this"
  ]

#  provisioner "file" {
#    destination = var.file_destination
#    source      = var.file_source
#  }

  provisioner "shell" {
    script = "jenkins.sh"
  }
}
