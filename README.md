# ⚠️ WARNING ⚠️

Everything in here is *heavily* customized for my homelab. It will not work for you as-is, but feel free to use it as inspiration.

# homelab-infra-terraform

[![Terraform Checks](https://github.com/loganmarchione/homelab_infra/actions/workflows/terraform_checks.yml/badge.svg)](https://github.com/loganmarchione/homelab_infra/actions/workflows/terraform_checks.yml)

A collection of Terraform files

## Explanation

This directory contains the directories below. See each directory for a more detailed `README.md`.

| Directory                  | What it manages                                       | Status                    |
|----------------------------|-------------------------------------------------------|---------------------------|
| [`bootstrap`](bootstrap)   | S3 bucket holding Terraform state for all directories | Stable, rarely changes    |
| [`external`](external)     | External services (DNS, sites, email, DigitalOcean)   | In use                    |
| [`talos`](talos)           | Talos Kubernetes cluster config                       | Testing                   |

Some notes:
- `bootstrap` must be applied first. It creates the S3 bucket that every other directory uses as its backend. The other directories are independent of each other and can be applied in any order.
- `bootstrap`'s state lives in the bucket that it manages (self-reference).
