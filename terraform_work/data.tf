data "aws_caller_indentity" "current" {}

data "aws_vpc" "this"{
    id = var.vpc_id
}
data "aws_subnet" "public1"{
    id = var.public_subnet1
}