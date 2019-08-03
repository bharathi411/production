provider "aws" {
output "public_subnet_aza_id" {
  value = "${aws_subnet.public-subnet-aza.id}"
}
  region  = "${var.region}"
  profile = "${var.profile}"
}

module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "${var.vpc_cidr}"
  route_zone_name     = "${var.route53_zone_name}"
  pub_subnet_aza_cidr = "${var.pub_sub_a_cidr}"
  pub_subnet_azb_cidr = "${var.pub_sub_b_cidr}"
  pvt_subnet_aza_cidr = "${var.app_sub_a_cidr}"
  pvt_subnet_azb_cidr = "${var.app_sub_b_cidr}"
  ami_id              = "${var.openvpn_ami_id}"
  public_key_path     = "~/.ssh/id_rsa.pub"
  project             = "chqbook"
  env                 = "prod"
  aws_region          = "${var.region}"
}

module "db_sub_a" {
    source                  = "../../modules/subnet"
    vpc_id                  = "${module.vpc.vpc_id}"
    cidr                    = "${var.db_sub_a_cidr}"
    az                      = "${var.region}a"
    name                    = "${var.db_sub_a_name}"
    map_public_ip_on_launch = "false"
}

module "db_sub_b" {
    source                  = "../../modules/subnet"
    vpc_id                  = "${module.vpc.vpc_id}"
    cidr                    = "${var.db_sub_b_cidr}"
    az                      = "${var.region}b"
    name                    = "${var.db_sub_b_name}"
    map_public_ip_on_launch = "false"
}

module "management_sub_a" {
    source                  = "../../modules/subnet"
    vpc_id                  = "${module.vpc.vpc_id}"
    cidr                    = "${var.management_sub_a_cidr}"
    az                      = "${var.region}a"
    name                    = "${var.management_sub_a_name}"
    map_public_ip_on_launch = "false"
}

module "db_sn_a_association" {
  source           = "../../modules/subnet_association"
  subnet_id        = "${module.db_sub_a.id}"
  route_table_id   = "${module.vpc.private_route_table_id}"
}

module "db_sn_b_association" {
  source           = "../../modules/subnet_association"
  subnet_id        = "${module.db_sub_b.id}"
  route_table_id   = "${module.vpc.private_route_table_id}"
}

module "management_sn_a_association" {
  source           = "../../modules/subnet_association"
  subnet_id        = "${module.management_sub_a.id}"
  route_table_id   = "${module.vpc.private_route_table_id}"
}

module "vpc_peering" {
  source                    = "../../modules/vpc_peering"
  peer_vpc_id               = "${module.vpc.vpc_id}"
  source_vpc_id             = "${var.source_vpc_id}"
  auto_accept               = "true"
  peer_vpc_route_table_id   = "${module.vpc.public_route_table_id}"
  source_vpc_cidr           = "${var.source_vpc_cidr}"
  source_vpc_route_table_id = "${var.source_route_table_id}"
  peer_vpc_cidr             = "${var.peer_vpc_cidr}"
}

resource "aws_route" "vpc_private_aza_association" {
  route_table_id            = "${module.vpc.private_route_table_id}"
  destination_cidr_block    = "${var.source_vpc_cidr}"
  vpc_peering_connection_id = "${module.vpc_peering.aws_peering_id}"
}
