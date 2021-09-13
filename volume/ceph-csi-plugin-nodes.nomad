job "ceph-csi-plugin-nodes" {
  datacenters = ["dc1"]
  type        = "system"
  group "nodes" {
    network {
      port "metrics" {}
    }

    task "ceph-node" {
      driver = "docker"
      template {
        data        = <<EOF
[{
    "clusterID": "b9127830-b0cc-4e34-aa47-9d1a2e9949a8",
    "monitors": [
  "192.168.88.201"
    ]
}]
EOF
        destination = "local/config.json"
        change_mode = "restart"
      }
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
          "--drivername=rbd.csi.ceph.com",
          "--nodeserver=true",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${node.unique.name}",
          "--instanceid=${node.unique.name}-nodes",
          "--pidlimit=-1",
    "--logtostderr=true",
          "--v=5",
          "--metricsport=$${NOMAD_PORT_metrics}"
        ]
        privileged = true
      }
   resources {
        cpu    = 500
        memory = 256
      }
      service {
        name = "ceph-csi-nodes"
        port = "metrics"
        tags = [ "prometheus" ]
      }
csi_plugin {
        id        = "ceph-csi"
        type      = "node"
        mount_dir = "/csi"
      }
    }
  }
}