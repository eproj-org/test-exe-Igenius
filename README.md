# test- exe for IGenius
prerequisiti : Network  e subnetwork esistenti con serizio di NAT attivo ( per accesso a github apt-repo  docker hub)

Lancio ambiente terraform (es.):
 tf apply/apply  -var 'network=testig-exe-test' -var 'subnetwork=snet-exe-ig-1test'

command to test 

curl -vvv -G -d 'parent=projects/dotted-hulling-291009' http://<ip addr >:8080/assets.list

curl -vvv -G -d 'project=dotted-hulling-291009' -d 'zone=us-central1-a' http://127.0.0.1:8080/compute.list


Crea : 

