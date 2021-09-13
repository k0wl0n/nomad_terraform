type = "csi"
id   = "ceph-mysql-104-2"
name = "ceph-mysql-104-2"
external_id     = "0001-0024-7635de36-ab1f-4a70-98a2-a1bd80ba77c4-0000000000000006-6e696bba-064f-11ec-a251-0242ac110002"                          
access_mode     = "single-node-writer"
attachment_mode = "file-system"
mount_options {
  fs_type = "ext4"
}
plugin_id       = "ceph-csi"
secrets {
  userID  = "admin"
  userKey = "AQAVUCdhj8DLCBAAKA9WzcQG6u44EeNooNObug=="  
}
context {  
  clusterID = "7635de36-ab1f-4a70-98a2-a1bd80ba77c4"
  pool      = "kowlon_rbd"
  imageFeatures = "layering"
}