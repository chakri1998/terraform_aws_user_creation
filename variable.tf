variable "aws_access_key" {
  default = "AWS_ACCESS_KEY"
}

variable "aws_secret_key" {
  default = "AWS_SECRET_KEY"
}

variable "region" {
  default = "us-west-1"
}

variable "add_policy" {
  description = "want to attach policy enter yes to add and enter any key to  cancel"
}

variable "add_ssh_key" {
  description = "want to attach ssh key enter yes to add and enter any key  to cancel"
}

variable "user_name" {
  description = "please enter the user name in format of list to be created."
  type        = "list"
}

variable "policy_path" {
  description = "here are the policy path list."
  type        = "list"

  #default     = ["/home/ubuntu/user/policy/policy.json", "/home/ubuntu/user/policy/s3.json"]
}

variable "attach_group" {
  description = "want to attach to group enter new to create new group and attach user to it or enter existing to and user to exisitng group  and enter any key to  cancel"
}

variable "group_name" {
  description = "please enter the group name."
}

variable "email" {
  description = "please enter the email of the users."
  type        = "list"

  #default = ["chakradhar1998@outlook.com", "devarakondachakradhar1998@gmail.com"]
}
variable "policy_name" {
  description = "please enter the email of the users."
  type        = "list"

  #default = ["chakradhar1998@outlook.com", "devarakondachakradhar1998@gmail.com"]
}

variable "ssh_key_path" {
  description = "here are the policy path list."
  type        = "list"

  #default     = ["/home/ubuntu/user/policy/policy.json", "/home/ubuntu/user/policy/s3.json"]
}

