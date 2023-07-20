locals {
  tags = {
    cost    = "dms"
    creator = "terraform"
    git     = var.git
  }
}

# Create random numbers for each of the rules to use as rule-id
resource "random_string" "this" {
  for_each = toset(concat(var.exclude_tables, ["include"], ["rename"]))
  length   = 6
  special  = false
  lower    = false
  upper    = false
  numeric  = true
}