variable "cluster_name" {
  description = "The name for the Talos cluster"
  default     = "hydrogen"
  type        = string
}

variable "cluster_vip" {
  description = "The VIP for the Talos cluster"
  default     = "10.10.1.40"
  type        = string
}

# https://github.com/kubernetes/kubernetes/releases
variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.36.5"
  type        = string
}

# This changes on upgrades of Talos
# https://github.com/siderolabs/talos/releases
variable "talos_version" {
  description = "Talos Linux version"
  default     = "1.14.1"
  type        = string
}

# DO NOT CHANGE
# Config contract, pinned to the version the cluster was created with
# Independent of talos_version
variable "talos_contract_version" {
  description = "Talos Linux version during initial creation"
  default     = "1.14.1"
  type        = string
}

variable "schematic_id" {
  description = "Image Factory schematic ID"
  default     = "88d1f7a5c4f1d3aba7df787c448c1d3d008ed29cfb34af53fa0df4336a56040b"
  type        = string
}

variable "node_data" {
  description = "Control plane nodes, keyed by IP. Exactly one node must set primary = true; it becomes the bootstrap target. install_disk is matched via CEL against disk.dev_path."
  type = object({
    controlplanes = map(object({
      hostname     = string
      install_disk = string
      primary      = optional(bool, false)
    }))
  })
  default = {
    controlplanes = {
      "10.10.1.41" = {
        hostname     = "protium"
        install_disk = "/dev/sda"
        primary      = true
      },
      "10.10.1.42" = {
        hostname     = "deuterium"
        install_disk = "/dev/sda"
      },
      "10.10.1.43" = {
        hostname     = "tritium"
        install_disk = "/dev/sda"
      }
    }
  }
}