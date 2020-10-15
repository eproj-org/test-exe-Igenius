# test- exe for IGenius

This repository contains ( for easyness sake is the same repository) :
1) python application (REST api) integrated with stackdriver Logging
2) terraform script 

Requirements : Network  and subnetwork should exist with Nat service RUNNING ( to access  github repo, apt repo and dockerhub)

Terraform scripts create the following resources:

 - nr.2 loadbalancer (esterno ed interno di tipo Network)
 - nr.1 managed istance group with autoscaler (the same for the 2 ldbalancer)
 - nr.1 istanc template
 - firewallrules for service and health-check and ssh traffic 
 - healing service healchecks

 More specifically:

 google_compute_firewall.pythonapp-lb-fw

 google_compute_forwarding_rule.external

 google_compute_forwarding_rule.internal

 google_compute_health_check.pythonapp

 google_compute_http_health_check.pythonapp

 google_compute_region_backend_service.internal

 google_compute_target_pool.pythonapp-pool

 data.template_file.startup_script_config

 google_compute_firewall.pythonapp-healthcheck_autoheal

 google_compute_firewall.pythonapp-lb-network-allow-sh

 google_compute_health_check.pythonapp_autohealing_health_check[0]

 google_compute_instance_template.pythonapp-template[0]

 google_compute_region_autoscaler.pythonapp_autoscaler[0]

 google_compute_region_instance_group_manager.pythonapp-group-manager[0]


 FLOW TO START/DEPLOY

- Project creation

- "cd terraform"

- "rm -rf .terraform"  for a second project creation

- create a bucket (all the exe has been tested with us-central1 region bucket is glob resource)

- "terraform init" -> give the bucket name

- "cp main.example  main.tf" main.tf is a unique source of truth 

- edit main.tf to set in provider blocks the project-id just created/selected

- terraform plan/apply  -var 'network=vpc-name' -var 'subnetwork=subnet-name'

- terraform destroy  -var 'network=vpc-name' -var 'subnetwork=subnet-name'

Note :
1) the service account used by terraform needs  "serviceaccountuser" role in addition of normal role compute.write storage.write, e network.update   
2) the service account used in vm (istance tempalete ) should have asset.reader credentials  and should be granted to terraform's service account
3) update service_account.email field in python-group/variables.tf file


Commands used to test (examples) :

curl -vvv -G -d 'parent=projects/dotted-hulling-291009' http://<ip addr >:8080/assets.list

curl -vvv -G -d 'project=dotted-hulling-291009' -d 'zone=us-central1-a' http://127.0.0.1:8080/compute.list



BRANCH FLSKINDOCKER

Notes:

1) the helper for cli docker pull/push used is: gcloud auth configure-docker

2) the service account in vm (nbr2 in previous note ) should have "container registry agent" credentials

3) the container is intented to be used for development phases (it fetches from github repository a branch in dev for example). in addition to this the python files can be patched ( mounting Cos filesystem xx/empty directory and copying the files to modify on VOLUME in the container)

4) the logging agent is not installed but can be containerized as well . The logs files could be shared between Host and container but is a burden (keep in mind that in Cos  the main part of filesystem is ephemeral..). The best solution is to get stdout/stder at docker level and redirect towards the agent. TBD


PROJECTs INITIALIZATION

The projects here are assumeed to be already existent (and in part configured)
The service API enabled for this project (in addition to thse already enable by default - no doc exists on by default enabled) are : 

- cloudasset.googleapis.com         Cloud Asset API
- containerregistry.googleapis.com  Container Registry API

 the object terraform to enable apis is :

```
# Enable services in newly created GCP Project.
resource "google_project_service" "gcp_services" {
  count   = length(var.gcp_service_list)
  project = google_project.demo_project.project_id    ### Project managed/created by terraform
  service = var.gcp_service_list[count.index]

  disable_dependent_services = true
}
```
