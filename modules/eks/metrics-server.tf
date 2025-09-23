resource "helm_release" "metrics_server" {
  depends_on       = [module.eks]
  namespace        = "metrics"
  create_namespace = true

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.8.2"


  set {
    name  = "args"
    value = "{--kubelet-insecure-tls}"
  }
}