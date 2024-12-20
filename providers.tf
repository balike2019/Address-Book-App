
provider "aws" {
  region = us-east-1
  alias  = "us-east-1"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

provider "helm" {

  alias = "baliketech-cluster"
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster-auth.token
#load_config_file       = false  // load_config_file = false:
#Disables loading the local kubeconfig file. This setting is useful when you want to avoid relying on a local kubeconfig file, instead passing in all credentials and configuration directly.

  }
}


data "aws_eks_cluster_auth" "cluster-auth" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}


