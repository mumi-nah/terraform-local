# Data sources requirement: this reads a file that already exists on disk
# (committed with the repo) rather than one Terraform manages/creates.
# It's a good example of "pull in existing information" vs "create a resource".
data "local_file" "app_template" {
  filename = "${path.module}/templates/app.conf.tpl"
}
