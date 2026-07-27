data "local_file" "app_template" {
  filename = "${path.module}/templates/app.conf.tpl"
}
