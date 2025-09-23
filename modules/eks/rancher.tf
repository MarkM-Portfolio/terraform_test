resource "helm_release" "rancher" {
  depends_on       = [module.eks]
  namespace        = "cattle-system"
  create_namespace = true

  name       = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  chart      = "rancher"
  version    = "v2.5.12"


  set {
    name  = "ingress.tls.source"
    value = "secret"
  }

  set {
    name  = "hostname"
    value = var.rancher_hostname_in
  }
  set {
    name  = "ingress.extraAnnotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }
}