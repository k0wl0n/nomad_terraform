id           = "ceph_mysql_data"
name         = "mysql_data"
type         = "csi"
plugin_id    = "ceph-csi"
capacity_max = "2G"
capacity_min = "1G"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}

secrets {
  userID  = "admin"
  userKey = "AQAVUCdhj8DLCBAAKA9WzcQG6u44EeNooNObug=="
}

parameters {
  clusterID = "7635de36-ab1f-4a70-98a2-a1bd80ba77c4"
  pool = "nomad"
  imageFeatures = "layering"
}
mount_options {
  fs_type     = "ext4"
  mount_flags = ["rw"]
}