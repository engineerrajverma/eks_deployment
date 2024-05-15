# need VPC modules

module "vpc" {
    source ="terraform-aws-modules/vpc/aws"

    name = "jenkins-vpc"
    cidr = "10.0.0.0/16"

    azs        = data.aws_availability_zones
   # private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    public_subnets  = var.pubilc_subnets

    enable_dns_hostnames = true
    map_public_ip_on_launch =true
    enable_nat_gateway =true
    enable_vpn_gateway =true

    tags = {
        Name = "jenkins_vpc
        Terraform   = "true"
        Environment = "dev"
    }

    pubilc_subnet_tags ={
        Name = "jenkins_subnet"
    }
}

#security_grp
module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "jenkins-sg"
  description = "Security group for jekins-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
    from_port =8080 #this port is for jenkins
    to_port = 8080 #this port is for jenkins
    protocol = "tcp"
    description = "HTTP"
    cidr_block = "0.0.0.0/0"
    },
    {
    from_port =22 
    to_port = 22
    protocol = "tcp"
    description = "SSH"
    cidr_block = "0.0.0.0/0" 
    }
  ]
  egress_cidr_blocks  = [ {
        from_port =0
    to_port = 0
    protocol = "-1"
    cidr_block = "0.0.0.0/0" 
  }
  ]
  tags = {
    Name = "jenkins_sg"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type          = var.instance_type
  key_name               = "user1"
  monitoring             = true
  #vpc_security_group_ids = ["sg-12345678"]
   vpc_security_group_ids =  module.jenkins_sg.vpc_security_group_id

  #subnet_id              = "subnet-eddcdzz4"
  subnet_id              = module.vpc.pubilc_subnets[0]
  ami = data.aws_ami.volvo_demo.id
  associate_public_ip_address =true
  availablility_zones = data.aws_availablility_zones.azs.names[0]
  user_data = file("jenkins-install.sh")

  tags = {
    Name = "jenkins-server"
    Terraform   = "true"
    Environment = "dev"
  }
}