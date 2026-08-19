output "autoscaling_group_id" {
  value = aws_autoscaling_group.app.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.app.latest_version
}
