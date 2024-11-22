output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}
output "subnet01_id" {
  value = aws_subnet.custom_subnet01.id    // public
}
output "subnet02_id" {
  value = aws_subnet.custom_subnet02.id    // public
}
output "subnet03_id" {
  value = aws_subnet.custom_subnet03.id
}
output "subnet04_id" {
  value = aws_subnet.custom_subnet04.id
}