services {
  check {
    tcp = "127.0.0.1:3310"
    timeout = "5s"
    interval = "30s"
  }
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name   = "carbonio-clamav-signature-provider"
            local_bind_port    = 20000
            local_bind_address = "127.78.0.20"
          }
        ]
      }
    }
  }
  name = "carbonio-clamav"
  port = 3310
}
