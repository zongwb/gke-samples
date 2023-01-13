The sample app demonstrates the following capabilities:
- How to create a K8S service account and bind it to a GCP service account, in order to access Google managed resources.
- How to securely and conveniently connect to a Cloud SQL (PostgreSQL) instance from a K8S pod.
- How to deploy a separate app ingress.


### Create the GKE service account
[We enable Workload Identity to access Google Cloud services](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#overview), so that we don't need to inject service account credentials into the runtime containers.

*Do this only ONCE after the cluster is created. You'll probably need Project Editor permission.*
```
make create_k8s_sa
```

To verify its status:
```
kubectl describe serviceaccount --namespace $K8S_NS $K8S_SA
gcloud iam service-accounts get-iam-policy $APP_SA_NAME@$PROJECT_ID.iam.gserviceaccount.com
```


### Connect to a Cloud SQl instance
It follows the sidecar pattern (https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine#run_the_as_a_sidecar). The DB password is saved into a K8S secret, which needs to be deployed *before* the app.
```
make deploy_db_secrets
```

### Deploy a separate ingress
This demo serves requests at "https://$BASE_DOMAIN/db-demo". A separate ingress needs to be configured, i.e. in addition to whatever other ignresses that already exist. All the ingresses are managed by the same `ingress controller`.
```
make deploy_db_demo
make db_demo_ingress
```

### Misc
Build the app into a docker image and push to a registry, before deploying the app:
```
make build_image
make push_image
```