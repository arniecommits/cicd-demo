#define provider
provider "aws" {
    region = lookup(var.awsprops, "region")
}

resource "aws_security_group" "project-iac-sg" {

    name = lookup(var.awsprops, "secgroupname")
    description = lookup(var.awsprops, "secgroupname")
    vpc_id = lookup(var.awsprops, "vpc")

    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }    


}

resource "aws_instance" "project-iac-ec2" {
    
    ami = lookup(var.awsprops, "ami")
    instance_type = lookup(var.awsprops, "itype")
    subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
    associate_public_ip_address = lookup(var.awsprops, "publicip")
    key_name = lookup(var.awsprops, "keyname")
    
    vpc_security_group_ids = [
        aws_security_group.project-iac-sg.id
    ]

    root_block_device {
        delete_on_termination = true
        iops = 150
        volume_size = 50
        volume_type = "gp2"
    }

    depends_on = [ aws_security_group.project-iac-sg ]



}

output "ec2instance" {
  value = aws_instance.project-iac-ec2.public_ip
}