locals {
   projects = {
    prod = {
      project_id    = "dotted-hulling-291009"
      network_name  = "prod"
      networks = {
        no1_nodes      = "10.163.28.0/22",
        no2_nodes      = "10.163.24.0/24",
      }
      labels = {
        environment = "production"
      }
    }

    test = {
      project_id    = "dotted-hulling-291009"
      network_name  = "test"
      networks = {
        no1_nodes      = "10.163.156.0/22",
        no2_nodes      = "10.163.152.0/24",
      }
      labels = {
        environment = "test"
      }
    }
  }
}
