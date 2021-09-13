job "strapi-sepat--staging" {
  namespace = "core-service"
  datacenters = ["ap-southeast-1b"]
  type        = "service"

  group "mysqlc" {
    count = 1

    volume "volumec" {
      type      = "csi"
      read_only = false
      source    = "volumec"
      attachment_mode = "file-system"
      access_mode     = "single-node-writer"
    }

    network {
      port "db" {
        static = 3306
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "mysqlc" {
      driver = "docker"

      volume_mount {
        volume      = "volumec"
        destination = "/srv"
        read_only   = false
      }

      env {
        MYSQL_ROOT_PASSWORD = "password"
      }

      config {
        image = "hashicorp/mysql-portworx-demo:latest"
        args  = ["--datadir", "/srv/mysql"]
        ports = ["db"]
      }

      resources {
        cpu    = 512
        memory = 1024
      }

      service {
        name = "mysql"
        port = "db"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
