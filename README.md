# test- exe for IGenius
prerequisiti : Network  e subnetwork esistenti con serizio di NAT attivo ( per accesso a github apt-repo  docker hub)

Lancio ambiente terraform (es.):
 tf apply/apply  -var 'network=testig-exe-test' -var 'subnetwork=snet-exe-ig-1test'

command to test 

curl -vvv -G -d 'parent=projects/dotted-hulling-291009' http://<ip addr >:8080/assets.list

curl -vvv -G -d 'project=dotted-hulling-291009' -d 'zone=us-central1-a' http://127.0.0.1:8080/compute.list

contien  1 repository con  ( per semplicità  : lostesso  repository)
1) applicazione python
2) script terrafrom 
Crea :->>>>>>>>>>>> rispondenze al testo dell'esercizio 
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

