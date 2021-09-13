type = "csi"
id   = "ceph-mysql-3"
name = "ceph-mysql-3"
external_id     = "0001-0024-7635de36-ab1f-4a70-98a2-a1bd80ba77c4-0000000000000005-00000000-1111-2222-bbbb-cacacacacaca"                          
access_mode     = "single-node-writer"
attachment_mode = "file-system"
plugin_id       = "ceph-csi"
secrets {
  userID  = "admin"
  userKey = "AQDDOiZhXzgrDxAAPk7uk82IFl6zjHzrLvyK7g=="  
}
context {  
  clusterID = "7635de36-ab1f-4a70-98a2-a1bd80ba77c4"
  pool = "kowlon_rbd"
  imageFeatures = "layering"
}

parameters {
  pool = "kowlon_rbd"
}
