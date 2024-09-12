variable "REGION" {
  default = "us-west-2"
}

variable "ZONE1" {
  default = "us-west-2a"
}
variable "ZONE2" {
  default = "us-west-2b"
}
variable "ZONE3" {
  default = "us-west-2c"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-west-2 = "ami-02d3770deb1c746ec"
    us-west-1 = "ami-04fdea8e25817cd69"
  }
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "dovekey.pub"
}
variable "PRIV_KEY" {
  default = "dovekey"
}

variable "MYIP" {
  default = "122.162.147.178/32"

}