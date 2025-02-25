resource "google_storage_bucket" "example" {
  name     = var.name
  location = "EU"
}
