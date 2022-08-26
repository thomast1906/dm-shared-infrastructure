variable product {
  default = "dm"
}

variable location {
  default = "UK South"
}

variable env {}

variable tenant_id {}

variable jenkins_AAD_objectId {}

// TAG SPECIFIC VARIABLES
variable common_tags {
  type = map(string)
}

variable team_contact {
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#ccd-devops"
}

variable destroy_me {
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}

variable aks_infra_subscription_id {}

variable managed_identity_object_id {
  default = ""
}