variable "awsprops" {

    type = "map"
    default = {
    region = "us-east-1"
    vpc = "vpc-0e2998fe1122711f0"
    ami = "ami-087c17d1fe0178315"
    itype = "t2.micro"
    subnet = "subnet-08962b20efe742225"
    publicip = true
    keyname = "aws-labs"
    secgroupname = "SSHAccess"
  }

}
