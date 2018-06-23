##
## kube worker kickstart renderer
##
resource "matchbox_profile" "ignition_worker" {
  name                   = "ignition_worker"
  container_linux_config = "${file("./ignition/worker.ign.tmpl")}"
  kernel                 = "/assets/coreos/${var.container_linux_version}/coreos_production_pxe.vmlinuz"

  initrd = [
    "/assets/coreos/${var.container_linux_version}/coreos_production_pxe_image.cpio.gz",
  ]

  args = [
    "coreos.config.url=http://${var.matchbox_vip}:${var.matchbox_http_port}/ignition?mac=$${mac:hexhyp}",
    "coreos.first_boot=yes",
    "console=hvc0",
    "coreos.autologin",
  ]
}

##
## kickstart
##
resource "matchbox_group" "ignition_worker_0" {
  name    = "ignition_worker_0"
  profile = "${matchbox_profile.ignition_worker.name}"

  selector {
    mac = "52-54-00-1a-61-8c"
  }

  metadata {
    hostname           = "worker-0"
    hyperkube_image    = "${var.hyperkube_image}"
    ssh_authorized_key = "cert-authority ${chomp(tls_private_key.ssh_ca.public_key_openssh)}"
    default_user       = "${var.default_user}"
    hyperkube_image    = "${var.hyperkube_image}"
    manifest_url       = "http://${var.matchbox_vip}:${var.matchbox_http_port}/generic?manifest=worker"
    apiserver_url      = "https://${var.controller_vip}:${var.apiserver_secure_port}"

    cluster_cidr   = "${var.cluster_cidr}"
    cluster_dns_ip = "${var.cluster_dns_ip}"
    cluster_domain = "${var.cluster_domain}"
    cluster_name   = "${var.cluster_name}"

    store_if = "eth0"

    kubernetes_path = "${var.kubernetes_path}"
    docker_opts     = "--log-driver=journald"

    tls_ca            = "${replace(tls_self_signed_cert.root.cert_pem, "\n", "\\n")}"
    tls_bootstrap     = "${replace(tls_locally_signed_cert.bootstrap.cert_pem, "\n", "\\n")}"
    tls_bootstrap_key = "${replace(tls_private_key.bootstrap.private_key_pem, "\n", "\\n")}"
    tls_proxy         = "${replace(tls_locally_signed_cert.proxy.cert_pem, "\n", "\\n")}"
    tls_proxy_key     = "${replace(tls_private_key.proxy.private_key_pem, "\n", "\\n")}"
  }
}

resource "matchbox_group" "ignition_worker_1" {
  name    = "ignition_worker_1"
  profile = "${matchbox_profile.ignition_worker.name}"

  selector {
    mac = "52-54-00-1a-61-8d"
  }

  metadata {
    hostname           = "worker-1"
    hyperkube_image    = "${var.hyperkube_image}"
    ssh_authorized_key = "cert-authority ${chomp(tls_private_key.ssh_ca.public_key_openssh)}"
    default_user       = "${var.default_user}"
    hyperkube_image    = "${var.hyperkube_image}"
    manifest_url       = "http://${var.matchbox_vip}:${var.matchbox_http_port}/generic?manifest=worker"
    apiserver_url      = "https://${var.controller_vip}:${var.apiserver_secure_port}"

    cluster_cidr   = "${var.cluster_cidr}"
    cluster_dns_ip = "${var.cluster_dns_ip}"
    cluster_domain = "${var.cluster_domain}"
    cluster_name   = "${var.cluster_name}"

    store_if = "eth0"

    kubernetes_path = "${var.kubernetes_path}"
    docker_opts     = "--log-driver=journald"

    tls_ca            = "${replace(tls_self_signed_cert.root.cert_pem, "\n", "\\n")}"
    tls_bootstrap     = "${replace(tls_locally_signed_cert.bootstrap.cert_pem, "\n", "\\n")}"
    tls_bootstrap_key = "${replace(tls_private_key.bootstrap.private_key_pem, "\n", "\\n")}"
    tls_proxy         = "${replace(tls_locally_signed_cert.proxy.cert_pem, "\n", "\\n")}"
    tls_proxy_key     = "${replace(tls_private_key.proxy.private_key_pem, "\n", "\\n")}"
  }
}
