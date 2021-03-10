variable "ami_name" {
  type    = string
  default = "ubuntu_latest_ami"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "")}

source "amazon-ebs" "ubuntu" {
  ami_name = "packer created ${local.timestamp}"
  instance_type = "t2.micro"
 #region = "ap-southeast-2"
 #vpc_id = "vpc-023cc780e428c6331"
 #subnet_id = "subnet-0fd6985362d6ed83f"
  ssh_interface = "public_ip"
  associate_public_ip_address = "true" 
  source_ami_filter {
     filters = {
        name = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
        root-device-type = "ebs"
        virtualization-type = "hvm"
       }
     most_recent = true
     owners = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
   sources = ["source.amazon-ebs.ubuntu"]
   provisioner "shell" {
    script = "./update.sh"
  }

}
