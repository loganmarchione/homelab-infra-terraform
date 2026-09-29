locals {
  cluster_endpoint        = "https://${var.cluster_vip}:6443"
  installer_image         = "factory.talos.dev/metal-installer/${var.schematic_id}:v${var.talos_version}"
  primary_control_node_ip = one([
    for ip, node in var.node_data.controlplanes : ip if node.primary
  ])
}