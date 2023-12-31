resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.name}-${var.env}"
  subnet_ids = var.subnets
  tags       = merge(var.tags, { Name = "${var.name}-${var.env}" })
}
resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "RDS"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allow_db_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-${var.env}-sg" })
}

resource "aws_elasticache_parameter_group" "main" {
  family      = "redis6.x"
  name        = "${var.name}-${var.env}-pg"
  description = "${var.name}-${var.env}-pg"
  tags        = merge(var.tags, { Name = "${var.name}-${var.env}-pg" })
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.name}-${var.env}-elasticache"
  description                = "${var.name}-${var.env}-elasticache"
  node_type                  = var.node_type
  port                       = var.port
  parameter_group_name       = aws_elasticache_parameter_group.main.name
  automatic_failover_enabled = true
  engine                     = var.engine
  engine_version             = var.engine_version
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  security_group_ids         = [aws_security_group.main.id]
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  at_rest_encryption_enabled = true
  kms_key_id                 = var.kms_arn
  tags                       = merge(var.tags, { Name = "${var.name}-${var.env}-elasticache" })
}


