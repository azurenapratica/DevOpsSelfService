###variables state
variable "RESOURCE_GROUP_NAME_STATE" {
  type = string
}

variable "STORAGE_ACCOUNT_NAME_STATE" {
  type = string
}

variable "CONTAINER_NAME_STATE" {
  type = string
}

###variables pipeline
variable "RESOURCE_GROUP_NAME" {
  type = string
}

variable "LOCATION" {
  type = string
}

variable "SERVICE_PLAN" {
  type = string
}

variable "APP_SERVICE" {
  type = string
}