######################################################################################
# NGINX Ingress Controller references
# https://github.com/nginxinc/kubernetes-ingress/tree/v2.1.1/deployments/helm-chart
##https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/service/annotations/#lb-scheme value doc
######################################################################################
resource "helm_release" "nginx_ingress" {
  depends_on       = [module.eks]
  namespace        = "ingress-nginx"
  create_namespace = true

  name       = "nginx-ingress-controller"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "0.12.1"


  values = [
    "${file("../../modules/eks/nginx_ingress/values.yaml")}" ####need to optimize this
  ]

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.config.entries.allow-snippet-annotations"
    value = "true"
    type  = "string"
  }
  set {
    name  = "controller.config.use-forwarded-headers"
    value = "true"
    type  = "string"
  }
  set {
    name  = "controller.config.entries.set-real-ip-from"
    value = var.vpc_cidr_in
  }
  #set {
  #  name  = "controller.config.entries.real-ip-header"
  #  value = "X-Forwarded-For"
  #}
  set {
    name  = "controller.config.entries.real-ip-recursive"
    value = "on"
  }

  # Use a private network load balancer
  #  set {
  #    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
  #    value = "http"
  #  }

  #set {
  #  name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
  #  value = var.regional_certificate_arn_in
  #}

  #set {
  #  name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-ports"
  #  value = "https"
  #}

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = "true"
    type  = "string"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = "60"
    type  = "string"
  }
  #####LOGGING LEVEL - default 1
  set {
    name  = "controller.logLevel"
    value = "1"
    type  = "string"
  }
}

##### NEEDED TO GIVE TIME FOR VPC_LINK TO DETECT THE NEWLY CREATED NLB ####
resource "time_sleep" "wait_5_mins" {
  depends_on      = [helm_release.nginx_ingress]
  create_duration = "300s"
}