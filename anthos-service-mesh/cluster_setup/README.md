## Step by step guide
- [Perform some mandatory bootstrappings](#mandatory-bootstrapping)
- [Create the network and NAT](#create-the-network-and-nat)
- [Create the GKE cluster](#create-the-gke-cluster)
- [Create the internal DNS](#create-the-internal-dns)


### Mandatory bootstrapping
We use [Cloud KMS and CMEK](https://cloud.google.com/kubernetes-engine/docs/how-to/using-cmek#overview) to protect boot disks in our GKE cluster.

Go through each of the scripts and change the env variables as appropirate.

*Only do the following ONCE. You'll probably need Project Editor permission.*

```
make enable_apis
make configure_iam
make create_kms
make enable_os_login
make create_sa
```

Check status
```
gcloud services list --enabled --project $PROJECT_ID

../helpers/show_sa.sh $PROJECT_NUMBER@cloudbuild.gserviceaccount.com

gcloud kms keys list --keyring $KEY_RING --location $REGION --project $PROJECT_ID
```

### Create the network and NAT
Create a new network, firewall rules and NAT. Note we also delete the *default* network.

*Only do the following ONCE.*

```
make create_network
make delete_default_network
make setup_vpc_peering
make create_dns
```

### Create the GKE cluster
We create a *private* GKE cluster for better security as the nodes do not have external IPs. We use the NAT gateway created in the previous step to allow initiating traffic to the public Internet.

We create an Anthos Service Mesh ingress that handles external load balancing, TLS certificate management, and internal traffic management. Cloud Armor is also enabled.

*Normally only need do the following ONCE.*

```
make create_cluster
make create_asm_ingress
```

***Wait for the ingress IP to be assigned and update your DNS record.***


### Create the internal DNS
Create an internal DNS. The same DNS will be used for *all* services.

First, create a managed DNS zone:
```
make create_dns
```

Then, use `add_sql_dns_record.sh` as an example to create an internal DNS record.
