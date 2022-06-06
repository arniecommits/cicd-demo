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

    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
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
    subnet_id = lookup(var.awsprops, "subnet")
    associate_public_ip_address = lookup(var.awsprops, "publicip")
    key_name = lookup(var.awsprops, "keyname")
    iam_instance_profile = lookup(var.awsprops, "role")
    vpc_security_group_ids = [
        aws_security_group.project-iac-sg.id
    ]

    user_data = <<EOF
#!/bin/bash
sudo apt -y update && apt -y upgrade
sudo apt -y install php libapache2-mod-php apache2 composer imagemagick
sudo systemctl enable apache2
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin --filename=composer
cd /var/www && sudo composer require aws/aws-sdk-php-resources
sudo mkdir -p /var/www/data
sudo rm -f /etc/ImageMagick-6/policy.xml
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/dodgycoder/awss3pdfconverter.git /var/www/html/
sudo chown -R www-data:www-data /var/www/
sudo systemctl start apache2
EOF
    root_block_device {
        delete_on_termination = true
        volume_size = 50
        volume_type = "gp2"
    }

    depends_on = [ aws_security_group.project-iac-sg ]
    tags = {

        Name = "PDFFiles-App-Node"
        Environment = "Prod" 

    }


}

resource "aws_s3_bucket" "s3bucket" {
    bucket = lookup(var.awsprops,"bucketname") 
    acl = lookup(var.awsprops,"bucketacl")
    tags = {

        Name = "PDFFiles"
        Environment = "Prod" 

    }   
}

output "ec2instance" {
  value = aws_instance.project-iac-ec2.public_ip
}
