job "docs" {
  datacenters = ["ap-southeast-1a","ap-southeast-1c","ap-southeast-1e"]

  group "example" {
    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"

        args = [
          "-listen",
          ":5678",
          "-text",
          "hello world",
        ]
      }

      resources {
        network {
          mbits = 10

          port "http" {
            static = "5678"
          }
        }
      }
    }
  }
}
