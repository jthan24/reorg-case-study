locals {
  # Common tags to be assigned to all resources
  common_tags = {
    project     = "reorg"
    study       = "case"
    managedby   = "terraform"
    owner       = "jthan24"
    vsc         = "https://github.com/jthan24/reorg-case-study"
    costcenter  = "case-study"
    environment = "prod"
  }

  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
