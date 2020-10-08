# test- exe for IGenius

This repository contains ( for easyness sake is the same repository) :
1) python application (REST api) integrated with stackdriver Logging
2) terraform script 

Requirements : Network  and subnetwork should exist with Nat servicE RUNNING ( to access a github apt-repo and dockerhub)

Terraform scripts create the following resources:

 2 loadbalancer (esterno ed interno di tipo Network)
 1 managed istance group with autoscaler (the same for the 2 ldbalancer)
 1 ist template
 ...firewallrule + healing  service healcheck

 module.staging-external-lb.google_compute_firewall.pythonapp-lb-fw
 module.staging-external-lb.google_compute_forwarding_rule.external
 module.staging-external-lb.google_compute_forwarding_rule.internal
 module.staging-external-lb.google_compute_health_check.pythonapp
 module.staging-external-lb.google_compute_http_health_check.pythonapp
 module.staging-external-lb.google_compute_region_backend_service.internal
 module.staging-external-lb.google_compute_target_pool.pythonapp-pool
 module.staging-pythonapp-pool.data.template_file.startup_script_config
 module.staging-pythonapp-pool.google_compute_firewall.pythonapp-healthcheck_autoheal
 module.staging-pythonapp-pool.google_compute_firewall.pythonapp-lb-network-allow-sh
 module.staging-pythonapp-pool.google_compute_health_check.pythonapp_autohealing_health_check[0]
 module.staging-pythonapp-pool.google_compute_instance_template.pythonapp-template[0]
 module.staging-pythonapp-pool.google_compute_region_autoscaler.pythonapp_autoscaler[0]
 module.staging-pythonapp-pool.google_compute_region_instance_group_manager.pythonapp-group-manager[0]

 FLOW TO START/DEPLOy

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

