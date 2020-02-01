
[启动仪表板参数文档](https://github.com/kubernetes/dashboard/wiki/Dashboard-arguments)

查看登录token
```bash
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep namespace | awk '{print $1}')

kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
```

启动HTTP代理
```bash
kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$'  --disable-filter=true
```

Log
```bash
kubectl logs $(kubectl get pods -A | grep kubernetes-dashboard | awk '{print $2}')  --namespace=kube-system
```

```bash
kubectl -n kube-system get svc kubernetes-dashboard

kubectl get pods --all-namespaces -o wide

kubectl get pods --namespace=kube-system
```

wget --no-check-certificate https://localhost/ui
