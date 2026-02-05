##########################################
#         GLOBAL SECURITY GROUPS         #
##########################################

# Allow All Traffic (Inbound + Outbound)
# OPTIONAL — disabled
/*resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_traffic"
  }
}*/

##########################################
#       SSH Security Group + Rules
##########################################

resource "aws_security_group" "ssh" {
  name        = "ssh-sg"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ssh_only_sg"
  }
}

# Allow SSH from trusted IP
resource "aws_vpc_security_group_ingress_rule" "ssh_from_mpIP" {
  security_group_id = aws_security_group.ssh.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.trusted_ip
}

# Allow SSH within same SG
resource "aws_vpc_security_group_ingress_rule" "ssh_self" {
  security_group_id            = aws_security_group.ssh.id
  referenced_security_group_id = aws_security_group.ssh.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

##########################################
#        DEVOPS STACK: SG Definitions
##########################################

# Jenkins SG
/*resource "aws_security_group" "jenkins_master" {
  name        = "jenkins-master-sg"
  description = "Jenkins Master SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "jenkins-master-sg"
  }
}*/

# Nexus SG
/*resource "aws_security_group" "nexus" {
  name        = "nexus-sg"
  description = "Nexus Repository Manager SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "nexus-sg"
  }
}*/

# Sonar SG
/*resource "aws_security_group" "sonarqube" {
  name        = "sonarqube-sg"
  description = "SonarQube SG"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sonarqube-sg"
  }
}*/

##########################################
#         Application Ports Access
##########################################

# Jenkins (8080)
/*resource "aws_security_group_rule" "jenkins_http_trusted" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [var.trusted_ip]
  security_group_id = aws_security_group.jenkins_master.id
}*/

# Nexus (8081)
/*resource "aws_security_group_rule" "nexus_http_trusted" {
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = [var.trusted_ip]
  security_group_id = aws_security_group.nexus.id
}*/

# SonarQube (80)
/*resource "aws_security_group_rule" "sonar_http_trusted" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.trusted_ip]
  security_group_id = aws_security_group.sonarqube.id
}*/

##########################################
#  Cross-Service Internal Dependencies
##########################################

# Jenkins → Nexus (upload artifacts)
/*resource "aws_security_group_rule" "jenkins_to_nexus" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nexus.id
  source_security_group_id = aws_security_group.jenkins_master.id
}*/

# Jenkins → Sonar (trigger analysis)
/*resource "aws_security_group_rule" "jenkins_to_sonar" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sonarqube.id
  source_security_group_id = aws_security_group.jenkins_master.id
}*/

# Sonar → Jenkins (webhooks)
/*resource "aws_security_group_rule" "sonar_to_jenkins" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins_master.id
  source_security_group_id = aws_security_group.sonarqube.id
}*/

# Ansible → nexus
/*resource "aws_security_group_rule" "ansible_to_nexus" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nexus.id
  source_security_group_id = aws_security_group.ssh.id
}*/

##########################################
#           GitHub Webhooks
##########################################

/*resource "aws_security_group_rule" "jenkins_webhook" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_master.id
}*/

##########################################
#           Egress Rules
##########################################

resource "aws_security_group_rule" "egress_ssh" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssh.id
}

/*resource "aws_security_group_rule" "egress_sonar" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sonarqube.id
}*/

/*resource "aws_security_group_rule" "egress_nexus" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nexus.id
}*/

/*resource "aws_security_group_rule" "egress_jenkins" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_master.id
}*/

##########################################
#       Monitoring Stack: SG Definitions 
##########################################

# Grafana SG
resource "aws_security_group" "grafana" {
  name        = "grafana-sg"
  description = "Allow for 3000 for grafana"
  vpc_id      = var.vpc_id

  ingress {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = [var.trusted_ip]
    }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "grafana_only_sg"
  }
}

resource "aws_security_group" "loki" {
  name        = "loki-sg"
  description = "Allow for 9090 for loki"
  vpc_id      = var.vpc_id

  ingress {
      from_port   = 3100
      to_port     = 3100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "loki_only_sg"
  }
}

resource "aws_security_group" "prometheus" {
  name        = "prometheus-sg"
  description = "Prometheus security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "prometheus_only_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "prometheus_ui" {
  security_group_id = aws_security_group.prometheus.id
  cidr_ipv4         = var.trusted_ip
  from_port         = 9090
  to_port           = 9090
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "prometheus_from_grafana" {
  security_group_id            = aws_security_group.prometheus.id
  referenced_security_group_id = aws_security_group.grafana.id
  from_port                    = 9090
  to_port                      = 9090
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "prometheus_all_out" {
  security_group_id = aws_security_group.prometheus.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
#========================================

resource "aws_security_group" "webApp" {
  name        = "webApp-sg"
  description = "Allow 5000 and 9100 for webApp"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webApp-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "webapp_5000_from_my_ip" {
  security_group_id = aws_security_group.webApp.id
  cidr_ipv4         = var.trusted_ip
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "webapp_9100_from_my_ip" {
  security_group_id = aws_security_group.webApp.id
  cidr_ipv4         = var.trusted_ip
  from_port         = 9100
  to_port           = 9100
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "webapp_5000_from_prometheus" {
  security_group_id            = aws_security_group.webApp.id
  referenced_security_group_id = aws_security_group.prometheus.id
  from_port                    = 5000
  to_port                      = 5000
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "webapp_9100_from_prometheus" {
  security_group_id            = aws_security_group.webApp.id
  referenced_security_group_id = aws_security_group.prometheus.id
  from_port                    = 9100
  to_port                      = 9100
  ip_protocol                  = "tcp"
}
