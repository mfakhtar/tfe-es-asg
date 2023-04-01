#Add Provider Block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}


#Add EC2 Block
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
/*
resource "aws_instance" "guide-tfe-es-ec2" {
  availability_zone           = var.az1
  ami                         = "ami-0f8ca728008ff5af4"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.guide-tfe-es-sg.id]
  subnet_id                   = aws_subnet.guide-tfe-es-sub.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key_pair.key_name

  root_block_device {
    volume_size = "50"
  }

  user_data = templatefile("${path.module}/user-data.sh", {
    bucket_name          = local.bucket_name
    region               = var.region
    tfe-pwd              = var.tfe-pwd
    tfe_release_sequence = var.tfe_release_sequence
    db_name              = aws_db_instance.default.db_name
    db_address           = aws_db_instance.default.address
    db_user              = var.db_user
    db_password          = var.db_pass
  })


  iam_instance_profile = aws_iam_instance_profile.guide-tfe-es-inst.id

}

output "ssh_public_ip" {
  description = "Command for ssh to the Client public IP of the EC2 Instance"
  value = [
    "ssh ubuntu@${aws_instance.guide-tfe-es-ec2.public_ip} -i key.pem"
  ]
}

*/
