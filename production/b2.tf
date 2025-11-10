resource "b2_bucket" "marchione-bucket02" {
  bucket_name = "marchione-bucket02"
  bucket_type = "allPrivate"

  default_server_side_encryption {
    algorithm = null
    mode      = "none"
  }

  lifecycle_rules {
    days_from_hiding_to_deleting  = 1
    days_from_uploading_to_hiding = 0
    file_name_prefix              = ""
  }
}
