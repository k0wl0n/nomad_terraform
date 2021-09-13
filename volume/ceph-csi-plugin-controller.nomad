job "ceph-csi-plugin-controller" {
  datacenters = ["dc1"]
group "controller" {
    network {
      port "metrics" {}
    }
    task "ceph-controller" {
template {
        data        = <<EOF
[{
    "clusterID": "7635de36-ab1f-4a70-98a2-a1bd80ba77c4",
    "monitors": [
  "192.168.88.201"
    ]
}]
EOF
        destination = "local/config.json"
        change_mode = "restart"
      }
      driver = "docker"
      config {
        image = "quay.io/cephcsi/cephcsi:v3.3.1"
        volumes = [
          "./local/config.json:/etc/ceph-csi-config/config.json"
        ]
        mounts = [
          {
            type     = "tmpfs"
            target   = "/tmp/csi/keys"
            readonly = false
            tmpfs_options = {
              size = 1000000 # size in bytes
            }
          }
        ]
        args = [
          "--type=rbd",
          "--controllerserver=true",
          "--drivername=rbd.csi.ceph.com",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${node.unique.name}",
    "--instanceid=${node.unique.name}-controller",
          "--pidlimit=-1",
    "--logtostderr=true",
          "--v=5",
          "--metricsport=$${NOMAD_PORT_metrics}"
        ]
      }
   resources {
        cpu    = 500
        memory = 256
      }
      service {
        name = "ceph-csi-controller"
        port = "metrics"
        tags = [ "prometheus" ]
      }
csi_plugin {
        id        = "ceph-csi"
        type      = "controller"
        mount_dir = "/csi"
      }
    }
  }
}