module "setup" {
  source = "./resources"
  resource_group = "Event-Hub-PoC"
  tags = {
    "project" = "EventHub"
  }
}