The sample app is downloaded from this tutorial: https://cloud.google.com/service-mesh/docs/unified-install/install-anthos-service-mesh-command.

This sample app demonstrates that we may partition the services into different namespaces, with each namespace corresponding to one business domain. It also shows how to access services in a different namespace.


Deploying is quite straightforward:
```
make namespaces
make deployments
make services
make app_ingress
```

Note: The ingress must be deployed to the **same namespace** as the entry application (which is *frontend* in this sample app). To check the ingress status:

```
kubectl -n frontend describe ing app-ingress
```