This repo demonstrates how to set up a backend application on GKE with the Anthos Service Mesh. It is largely based on and adapted from this excellent [tutorial](https://cloud.google.com/architecture/exposing-service-mesh-apps-through-gke-ingress).

Prerequisites
- `gcloud`
- `kubectl`
- `curl`
- `envsubst`
- `make`
- `base64`
- `docker`

Steps
- Create a new GCP project.
- Edit `example.env` to set the env vars, then `source example.env`
- `gcloud config set project $PROJECT_ID`
- Set up necessary resources and create the GKE cluster.
  - `cd cluster_setup`
  - `make help`
  - Read the README and run the each step in the Makefile from top.
  - There could be errors due to misconfiguraiton of the env vars. Look at the console output carefully and resolve them.
 
- Deploy the app to the GKE cluster
  - `cd app_setup`
  - `make help`
  - Read the README and run the each step in the Makefile from top


Additional info
- `db_demo` shows a few capabilities that are often needed:
  - How to create a K8S service account and bind it to a GCP service account, in order to access Google managed resources.
  - How to securely and conveniently connect to a Cloud SQL (PostgreSQL) instance.
  - How to deploy a separate app ingress.

Reference
- https://cloud.google.com/architecture/exposing-service-mesh-apps-through-gke-ingress