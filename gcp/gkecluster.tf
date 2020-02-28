// Configure the Google Cloud provider
provider "google" {
  credentials = file("creds/kube2020-tf.json")
  project     = "kube2020-266915"
  region      = "europe-west4"
}

resource "google_container_cluster" "C1" {
  name     = "c1"
  network  = "default"
  location = "europe-west4-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count        = 1
//  node_config {
//    // save money and use preemptible (~2 time cheeper) for stateless services
//    preemptible  = true
//    // f1-micro and e2-micro are the cheepest
//    machine_type = "e2-small"
    // 10GB is smalest allowed
//    disk_size_gb = 10
//
//    metadata = {
//      disable-legacy-endpoints = "true"
//    }

//    oauth_scopes = [
//      "https://www.googleapis.com/auth/devstorage.read_only",
//      "https://www.googleapis.com/auth/logging.write",
//      "https://www.googleapis.com/auth/monitoring"
//    ]
//  }

//  cluster_autoscaling {
//    enabled = true
//    resource_limits {
//      resource_type="memory"
//      minimum=1
//      maximum=4
//    }
//    resource_limits {
//      resource_type="cpu"
//      minimum=1
//      maximum=8
//    }
//
//  }


//addons_config {
//network_policy_config {
//disabled = true
//}
//
//http_load_balancing {
//disabled = false
//}
//
//kubernetes_dashboard {
//disabled = false
//}
//}

}

resource "google_container_node_pool" "P1" {
  name       = "p1"
  location   = "europe-west4-a"
  cluster    = google_container_cluster.C1.name
  initial_node_count = 1

  autoscaling {
    min_node_count = 0
    max_node_count = 4
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }



  node_config {
    // save money and use preemptible (~3 times cheeper) for stateless services
    preemptible  = true
    // f1-micro and e2-micro are the cheepest, but e2-small 2GB, e2-medium 4GB
    machine_type = "e2-small"
    // 10GB is smalest allowedde
    disk_size_gb = 10

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}

output "host" {
  value = "${google_container_cluster.C1.endpoint}"
}