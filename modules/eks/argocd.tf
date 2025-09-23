######################################################################################
# ArgoCD references
# https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd
######################################################################################
resource "helm_release" "argocd" {
  depends_on       = [module.eks]
  namespace        = "argocd"
  create_namespace = true

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.5.0"

  # Enable HA with autoscaling
  ### https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd#ha-mode-with-autoscaling
  set {
    name  = "redis-ha.enabled" #####NEED 3 NODES to be able to have ha
    value = false
  }
  set {
    name  = "controller.enableStatefulSet"
    value = true
  }
  set {
    name  = "server.autoscaling.enabled"
    value = true
  }
  set {
    name  = "server.autoscaling.minReplicas"
    value = 2
  }
  set {
    name  = "repoServer.autoscaling.enabled"
    value = true
  }
  set {
    name  = "repoServer.autoscaling.minReplicas"
    value = 2
  }
  set {
    name  = "server.extraArgs"
    value = "{--insecure}"
  }
  set {
    name  = "server.ingress.enabled"
    value = true
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.hosts"
    value = "{${local.argocd_url}}"
  }
  set {
    name  = "applicationSet.image.repository"
    value = var.ami_type_default_in == "AL2_x86_64" ? "quay.io/argoproj/argocd-applicationset" : "ghcr.io/jr64/argocd-applicationset"
  }
  set {
    name  = "applicationSet.image.tag"
    value = var.ami_type_default_in == "AL2_x86_64" ? "v0.4.1" : "v0.4.0"
  }
}