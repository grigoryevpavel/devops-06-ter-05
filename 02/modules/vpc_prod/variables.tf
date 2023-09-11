
### module vars
variable "env_name" {
  type        = string 
  description = "VPC network&subnet name"
}
variable "subnets"{
  type=list(object({zone=string,cidr=string})) 
} 
 