resource "talos_machine_secrets" "this" {
  talos_version = var.talos_contract_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = keys(var.node_data.controlplanes)
}

# Control plane configuration
data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_contract_version
  kubernetes_version = var.kubernetes_version

  config_patches = [
    # Stable alias for the virtio NIC, so ens18 vs eth0 stops mattering
    # All Proxmox MACs are prefixed with bc:24:11
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "LinkAliasConfig"
      name       = "lan0"
      selector = {
        match = "glob('bc:24:11:*', mac(link.permanent_addr))"
      }
    }),

    # Shared control plane VIP
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "Layer2VIPConfig"
      name       = var.cluster_vip
      link       = "lan0"
    }),

    # Allow workloads on control planes
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "KubeNodeConfig"
      taints = {
        "node-role.kubernetes.io/control-plane" = { "$patch" = "delete" }
      }
    }),
  ]
}

# Control plane apply
resource "talos_machine_configuration_apply" "controlplane" {
  for_each = var.node_data.controlplanes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = each.key

  config_patches = [
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "HostnameConfig"
      hostname   = each.value.hostname
      auto       = { "$patch" = "delete" }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "UnattendedInstallConfig"
      installer  = { image = local.installer_image }
      provisioning = {
        diskSelector = { match = "disk.dev_path == '${each.value.install_disk}'" }
        wipe         = true
      }
    }),
  ]
}

# Only bootstrap the cluster on the primary node
resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.primary_control_node_ip
}

# Only get the kubeconfig from the primary node
resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.primary_control_node_ip
}