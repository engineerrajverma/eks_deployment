#ami-data-source
data "aws_ami" "volvo_demo"{

    most_recent     = true
    owners          = ["amazon"]

    filter {
        name = "name"
        values = ["myami-*"]
    }
    filter {
        name  = "root-device-type"
        value = ["ebs"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_availablility_zones" "az"{
   # ["eu-west-1a","eu-west-1b","eu-west-1c"]
}