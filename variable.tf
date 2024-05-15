variable "vpc_cidr"{
    description = "vpc CIDR"
    type = string
}
variable "public_subnets" {
    decription = "public_subnets CIDR"
    type = list (string)
}

variable "instance_type" {
    decription = "instance_type"
    #type = list (string)

    type = string
}