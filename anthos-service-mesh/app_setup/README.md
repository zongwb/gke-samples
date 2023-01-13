The sample app is downloaded from this tutorial: https://cloud.google.com/service-mesh/docs/unified-install/install-anthos-service-mesh-command.

This sample app demonstrates that we may partition the services into different namespaces, with each namespace corresponding to one business domain. It also shows how to access services in a different namespace.

Deploying is quite straightforward:
```
make namespaces
make deployments
make services
make app_ingress
make add_custom_headers
```

The inbound traffic routing is handled by a VirtualService in the *frontend* namespace:
```
kubectl -n frontend get virtualservice
```