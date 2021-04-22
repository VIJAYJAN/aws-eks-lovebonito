resource "null_resource" "docker_image_build" { # Generate a kubeconfig (needs aws cli >=1.62 and kubectl)

  provisioner "local-exec" {
    command              = "docker build -t lovebonito/pass-manager:latest password-manager/."
  }
}