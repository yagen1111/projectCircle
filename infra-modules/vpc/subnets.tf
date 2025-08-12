resource "aws_subnet" "private" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets[count.index]
    availability_zone = var.azs[count.index]
    tags = merge(
        { Name = "${var.env}-private-subnet-${count.index + 1}" },
        var.private_subnets_tags
    )
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.azs[count.index]
    tags = merge(
        { Name = "${var.env}-public-subnet-${count.index + 1}" },
        var.public_subnets_tags
    )
}