id        = "bitwarden-prod-clone"
name      = "Bitwardedn_prod_clone"
type      = "csi"
plugin_id = "ceph-csi"
access_mode = "single-node-writer"
attachment_mode = "file-system"
capacity_min = "100MB"
capacity_max = "1GB"

secrets {
  userID  = "admin"
  userKey = "AQDDOiZhXzgrDxAAPk7uk82IFl6zjHzrLvyK7g=="  
}
parameters {
  # seeded from uuid5(ceph.example.com)
  clusterID     = "7635de36-ab1f-4a70-98a2-a1bd80ba77c4"
  pool          = "kowlon_rbd"
  imageFeatures = "layering"
}