################################
########## WEBSERVER ###########
################################

resource "aws_key_pair" "th-key" {
  key_name   = "ssh-key"
  public_key = file(var.path_to_public_key)

}

resource "aws_instance" "webserver" {
  count                       = 3
  ami                         = "ami-09b9e380df60300c8"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.th-key.key_name
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.instance_username
      private_key = file(var.path_to_private_key)
    }
  }
}
