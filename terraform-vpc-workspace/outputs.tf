output "vpc_id" {
  value = "${aws_vpc.main_vpc.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "private_subnet_id1" {
  value = "${element(aws_subnet.private.*.id, 0)}"
}

output "private_subnet_id2" {
  value = "${element(aws_subnet.private.*.id, 1)}"
}

output "database_subnet_ids" {
  value = ["${aws_subnet.database.*.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "subnet_group" {
  value = "${aws_db_subnet_group.RDS-subnet.id}"
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

/*
output "nat_gateway_id" {
  value = "${aws_nat_gateway.gw.id}"
}

output "nat_eip" {
  value = "${aws_eip.nat_eip.id}"
}*/
