variable "awsprops" {

    type = "map"
    default = {
    region = "eu-west-2"
    vpc = "vpc-0a4d722728421a267"
    ami = "ami-087c17d1fe0178315"
    itype = "t2.micro"
    subnet = "subnet-07cef9974d911f488"
    publicip = true
    keyname = "arnab-key"
    secgroupname = "Jenkins Access"
  }

}
