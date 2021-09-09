job "demo-webapp2" {
  datacenters = ["dc1"]
  group "demo" {
    count = 3
    network {
      port "demowebapp2" { to = 80 }
    }

    task "server" {

      driver = "docker"
      config {
        image = "mendhak/http-https-echo"
        ports = ["demowebapp2"]
      }

      resources {
        cpu    = 64
        memory = 64
      }
    }

    service {
      name = "demo-webapp2"
      port = "demowebapp2"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.app.rule=Host(\"app.kowlon.my.id\")",
      ]
      check {
        port     = "demowebapp2"
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }
  }
}