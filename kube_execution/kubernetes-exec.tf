resource "null_resource" "generate_kubeconfig" { # Generate a kubeconfig (needs aws cli >=1.62 and kubectl)

  provisioner "local-exec" {
    command              = "aws eks update-kubeconfig --name ${var.eks_cluster_name} --region ${var.region}"
  }

  depends_on             = [aws_eks_cluster.eks_cluster_main]
}

data "template_file" "aws_auth_configmap" { 

  template               = file("${path.module}/aws-auth.yaml.tpl")

  vars = {
    arn_instance_role    = aws_iam_role.eks_nodes_roles.arn
  }
}

resource "null_resource" "execute_aws_auth_configmap" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.aws_auth_configmap.rendered}' > aws-auth.yaml && kubectl apply -f aws-auth.yaml && rm aws-auth.yaml"
  }
  

  depends_on             = [null_resource.generate_kubeconfig]
}

data "template_file" "traefik_resourcedefinition" { 

  template               = file("${path.module}/traefik/traefik-resourcedefinition.yaml.tpl")
}

resource "null_resource" "execute_traefik_resourcedefinition" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.traefik_resourcedefinition.rendered}' > traefik-resourcedefinition.yaml && kubectl apply -f traefik-resourcedefinition.yaml && rm traefik-resourcedefinition.yaml"
  }
  
  depends_on             = [null_resource.generate_kubeconfig]
}

data "template_file" "traefik_serviceaccount" { 

  template               = file("${path.module}/traefik/traefik-serviceaccount.yaml.tpl")
}

resource "null_resource" "execute_traefik_serviceaccount" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.traefik_serviceaccount.rendered}' > traefik-serviceaccount.yaml && kubectl apply -f traefik-serviceaccount.yaml && rm traefik-serviceaccount.yaml"
  }
  
  depends_on             = [null_resource.generate_kubeconfig]
}

data "template_file" "traefik_rbac" { 

  template               = file("${path.module}/traefik/traefik-rbac.yaml.tpl")
}

resource "null_resource" "execute_traefik_rbac" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.traefik_rbac.rendered}' > traefik-rbac.yaml && kubectl apply -f traefik-rbac.yaml && rm traefik-rbac.yaml"
  }
  
  depends_on             = [null_resource.generate_kubeconfig]
}

data "template_file" "traefik_configmap" { 

  template               = file("${path.module}/traefik/traefik-configmap.yaml.tpl")
}

resource "null_resource" "execute_traefik_configmap" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.traefik_configmap.rendered}' > traefik-configmap.yaml && kubectl apply -f traefik-configmap.yaml && rm traefik-configmap.yaml"
  }
  
  depends_on             = [null_resource.generate_kubeconfig]
}

data "template_file" "traefik_daemonset" { 

  template               = file("${path.module}/traefik/traefik-daemonset.yaml.tpl")
}

resource "null_resource" "execute_traefik_daemonset" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.traefik_daemonset.rendered}' > traefik-daemonset.yaml && kubectl apply -f traefik-daemonset.yaml && rm traefik-daemonset.yaml"
  }
  
  depends_on             = [null_resource.generate_kubeconfig]
}

data "template_file" "pass_manager_deployment" { 

  template               = file("${path.module}/kube-deploy/pass-manager-deployment.yaml.tpl")
}

resource "null_resource" "execute_pass_manager_deployment" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.pass_manager_deployment.rendered}' > pass-manager-deployment.yaml && kubectl apply -f pass-manager-deployment.yaml && rm pass-manager-deployment.yaml"
  }
  
  depends_on             = [null_resource.docker_image_build]
}

data "template_file" "pass_manager_ingressroute" { 

  template               = file("${path.module}/kube-deploy/pass-manager-ingressroute.yaml.tpl")
}

resource "null_resource" "execute_pass_manager_ingressroute" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.pass_manager_ingressroute.rendered}' > pass-manager-ingressroute.yaml && kubectl apply -f pass-manager-ingressroute.yaml && rm pass-manager-ingressroute.yaml"
  }
  
  depends_on             = [null_resource.docker_image_build]
}

data "template_file" "pass_manager_traefikservice" { 

  template               = file("${path.module}/kube-deploy/pass-manager-traefikservice.yaml.tpl")
}

resource "null_resource" "execute_pass_manager_traefikservice" { 

  provisioner "local-exec" {
    command              = "echo '${data.template_file.pass_manager_traefikservice.rendered}' > pass-manager-traefikservice.yaml && kubectl apply -f pass-manager-traefikservice.yaml && rm pass-manager-traefikservice.yaml"
  }
  
  depends_on             = [null_resource.docker_image_build]
}

