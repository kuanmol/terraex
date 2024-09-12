provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "intro" {
  ami               = "ami-02d3770deb1c746ec"
  instance_type     = "t2.micro"
  availability_zone = "us-west-2a"
  key_name          = "dove.key"

  vpc_security_group_ids = ["sg-0659e76fca623b20c"]
  tags = {
    Name = "Dove-Instance"
    Project = "Dove"
  }
}
