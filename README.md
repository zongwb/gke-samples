This repo aims to demonstrate how to deploy an application in GKE, with Nginx or Anthos Service Mesh as the ingress controller. It is only for educational purposes and should **not** be used for production as such.

**Features**
- Necessary preparations before creating a GKE cluster.
- Create a private GKE cluster.
- Deploy apps to the GKE cluster.
- Use Workload Identity to access Google-managed resources.
- Connect to a Cloud SQL instance using the sidecar pattern.
- Create an internal DNS record for the apps.
- Expose the apps using Nginx or ASM.