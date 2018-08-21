##
## ssh ca key for provisioner nodes
##
resource "tls_private_key" "ssh_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "local_file" "ssh_ca_key" {
  content  = "${chomp(tls_private_key.ssh_ca.private_key_pem)}"
  filename = "output/ssh-ca-key.pem"
}