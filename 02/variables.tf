###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


variable "public_key" {
  type    = string
  default = ""
} 
variable "test" {
  type    = number
  default = 1000
  validation {
    condition     = var.test > 0
    error_message = "test must be more than 0"
  }
}
variable "test2"{
  type= list(number)
  default = []
  validation {
    condition     = length(var.test2)!=0
    error_message = "list must contain elements"
  }
}
variable "test3"{
  type= list 
  default =  [1,2,3,4] 
  validation {
    condition     = length(var.test3)!=0
    error_message = "list must contain elements"
  }
}
variable "ip_addr"{
  type=list(string)
  description="список ip-адресов"
  default = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
  validation {
    condition=alltrue([
      for v in var.ip_addr: can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$",v))
    ])
    error_message = "Invalid ip-address in list"
  }
}
variable "ip_addr2"{
  type=list(string)
  description="список ip-адресов"
  default =["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
  validation {
    condition=alltrue([
      for v in var.ip_addr2: can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$",v))
    ])
    error_message = "Invalid ip-address in list"
  }
}