provider "google" {
  project = "terraform-507810"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "my_vm" {
  name         = "terraform-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_container_cluster" "my_gke" {
  name     = "my-first-cluster"
  location = "us-central1-a"
  deletion_protection = false

  # We create node pool separately
  remove_default_node_pool = true
  initial_node_count       = 1

  network = "default"
}

resource "google_container_node_pool" "my_nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.my_gke.name
  location   = "us-central1-a"
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    image_type   = "COS_CONTAINERD"
    disk_size_gb = 20
  }
}