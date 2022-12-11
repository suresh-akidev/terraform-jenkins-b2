data "aws_vpc" "vpc_info" {
  filter {
    name = "state"
    values = ["available"]
  }
}

data "aws_subnet" "subnet_info" {
  vpc_id = data.aws_vpc.vpc_info.id
  filter {
    name = "tag:app_id"
    values = ["space_1234"]
  }
}

resource "aws_security_group" "terra-sg-01" {
  name = "terra-sg-today-01"
  description = "today class"
  vpc_id = ""
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "test"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress{
    cidr_blocks = ["0.0.0.0/0"]
    description = "test"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

}

resource "aws_instance" "ec2_test-01" {
  ami = "ami-074dc0a6f6c764218"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.subnet_info.id
  vpc_security_group_ids = [aws_security_group.terra-sg-01.id]
}


resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-157673692367"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
    depends_on = [
    aws_instance.ec2_test-01
  ]
}