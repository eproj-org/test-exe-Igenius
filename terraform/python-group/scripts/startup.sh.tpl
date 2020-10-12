#cloud-config

users:
- name: pythonapp
  uid: 2000

write_files:
- path: /etc/systemd/system/python-app.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Start a simple docker container with flask app

    [Service]
    ExecStart=/usr/bin/docker run --rm -u 2000 --name=mycloudservice gcr.io/${project}/app-python:latest 
    ExecStop=/usr/bin/docker stop mycloudservice
    ExecStopPost=/usr/bin/docker rm mycloudservice

runcmd:
- systemctl daemon-reload
- systemctl start python-app.service
