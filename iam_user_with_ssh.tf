provider "aws" {
  region     = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_iam_user" "user" {
  count = "${length(var.user_name)}"
  name  = "${var.user_name[count.index]}"
  path  = "/"
}

resource "aws_iam_access_key" "user" {
  count   = "${length(var.user_name)}"
  user    = "${element(aws_iam_user.user.*.name,count.index)}"
  pgp_key = "keybase:chakri1998"
}


output "user-name" {
  value = "${aws_iam_user.user.*.name}"
}

resource "aws_iam_user_login_profile" "example" {
  count   = "${length(aws_iam_user.user.*.name)}"
  user    = "${element(aws_iam_user.user.*.name,count.index)}"
  pgp_key = "keybase:chakri1998"
}


output "secret" {
  value = ["${aws_iam_access_key.user.*.encrypted_secret}"]
}

output "password" {
  value = ["${aws_iam_user_login_profile.example.*.encrypted_password}"]
}


resource "aws_iam_policy" "policy" {
  count       = "${var.add_policy == "yes" ? length(aws_iam_user.user.*.name) : 0}"
  count       = "${length(aws_iam_user.user.*.name)}"
  name        = "${element(var.policy_name,count.index)}"
  description = "A test policy by terraform test"
  policy      = "${file(element(var.policy_path, count.index))}"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  count      = "${var.add_policy == "yes" ? length(aws_iam_user.user.*.name) : 0}"
  count      = "${length(aws_iam_user.user.*.name)}"
  user       = "${element(aws_iam_user.user.*.name,count.index)}"
  policy_arn = "${element(aws_iam_policy.policy.*.arn,count.index)}"
}


output "policy_arn" {
  value = "${aws_iam_policy.policy.*.arn}"
}

resource "aws_iam_user_ssh_key" "user" {
  count      = "${var.add_ssh_key=="yes" ? length(aws_iam_user.user.*.name) : 0}"
  count      = "${length(aws_iam_user.user.*.name)}"
  username   = "${element(aws_iam_user.user.*.name, count.index)}"
  encoding   = "SSH"
  public_key = "${file(element(var.ssh_key_path, count.index))}"

}

resource "aws_iam_user_group_membership" "team" {
  count = "${var.attach_group == "new" ? length(aws_iam_user.user.*.name) : 0}"
  count = "${length(aws_iam_user.user.*.name)}"
  user  = "${element(aws_iam_user.user.*.name,count.index)}"

  groups = [
    "${aws_iam_group.group.name}",
  ]
}

resource "aws_iam_group" "group" {
  count = "${var.attach_group == "new" ? 1 : 0}"
  name  = "${var.group_name}"
}

data "aws_iam_group" "group" {
  count      = "${var.attach_group == "existing" ? 1 : 0}"
  group_name = "${var.group_name}"
}

resource "aws_iam_user_group_membership" "team-existing" {
  count = "${var.attach_group == "existing" ? length(aws_iam_user.user.*.name) : 0}"
  count = "${length(aws_iam_user.user.*.name)}"
  user  = "${element(aws_iam_user.user.*.name,count.index)}"

  groups = [
    "${data.aws_iam_group.group.group_name}",
  ]
}

output "var-mail" {
  value = "${jsonencode(var.email)}"
}

resource "null_resource" "mail" {
  # depends_on = ["aws_iam_user_login_profile.example", "aws_iam_access_key.user"]
  provisioner "local-exec" {
    command = <<EOT
  echo "${jsonencode(aws_iam_access_key.user.*.encrypted_secret)}" > secret
  echo "${jsonencode(aws_iam_user_login_profile.example.*.encrypted_password)}" > password  
  echo "${jsonencode(var.email)}" > email
  echo "${jsonencode(aws_iam_user.user.*.name)}" > username  
  sed -i 's/"//g; s/[][]//g; s/,/\ /g' email
  sed -i 's/\[/\["/g; s/\]/\"]/g; s/,/","/g' password
  sed -i 's/\[/\["/g; s/\]/\"]/g; s/,/","/g' secret
  sed -i 's/\[/\["/g; s/\]/\"]/g; s/,/","/g' username
  ./email.sh `cat email`
  
EOT
  }
}
