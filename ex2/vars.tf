variable "REGION" {
  default = "us-west-2"
}

variable "ZONE1" {
  default = "us-west-2a"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-west-2 = "ami-02d3770deb1c746ec"
    us-west-1 = "ami-04fdea8e25817cd69"
  }
}