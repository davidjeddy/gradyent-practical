# resource "aws_alb_target_group_attachment" "this" {

#   target_id        = element(var.instance_ids, count.index)
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
# }
