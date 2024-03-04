terraform {
  source = "tfr:///terraform-aws-modules/eks/aws//.?version=19.15.3"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  cluster_version                       = include.env.locals.eks_cluster_version
  cluster_name                          = include.env.locals.eks_cluster_name
  
  vpc_id                                = dependency.vpc.outputs.vpc_id
  subnet_ids                            = dependency.vpc.outputs.private_subnets
  
  // other optional inputs
  
  create_aws_auth_configmap             = include.env.locals.eks_create_aws_auth_configmap
  manage_aws_auth_configmap             = include.env.locals.eks_manage_aws_auth_configmap
}

dependency "vpc" {
  config_path = "${get_original_terragrunt_dir()}/../vpc"
  mock_outputs = {
    vpc_id = "vpc-00000000"
    private_subnets = [
      "subnet-00000000",
      "subnet-00000001",
      "subnet-00000002",
    ]
  }
}
