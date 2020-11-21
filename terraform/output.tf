output "ansible_server_public_address" {
    value = aws_instance.server.*.public_ip
}

output "ansible_nodes_public_addresses_ubuntu" {
    value = aws_instance.nodes_ubuntu.*.public_ip
}

output "ansible_nodes_private_addresses_ubuntu" {
    value = aws_instance.nodes_ubuntu.*.private_ip
}

output "ansible_nodes_public_addresses_centos" {
    value = aws_instance.nodes_centos.*.public_ip
}

output "ansible_nodes_private_addresses_centos" {
    value = aws_instance.nodes_centos.*.private_ip
}