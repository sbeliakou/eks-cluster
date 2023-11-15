resource "helm_release" "nginx-ingress" {
  count = var.nginx_ingress_enabled ? 1 : 0
  depends_on = [ module.eks  ]
  name = "nginx-ingress"
  chart = "oci://ghcr.io/nginxinc/charts/nginx-ingress"
  version = "1.0.1"
  namespace = "ingress-nginx"
  create_namespace = true
}

resource "helm_release" "metrics_server" {
  depends_on = [ module.eks  ]
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}