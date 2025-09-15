module "setup" {
  source = "./resources"
  resource_group = "Event-Hub"
  aks_name = "CZ-Event-Hub" //"czag01r457aks001"
  law_name = "CZ-Event-Hub" //"czag01r457law001"
  tags = {
    "project" = "CZ-Event-Hub"
  }
}