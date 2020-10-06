#!/bin/bash

# Echo commands
set -v

# [START getting_started_gce_startup_script]
# Install Stackdriver logging agent
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh

# Install or update needed software
apt-get update
apt-get install -yq git supervisor python python-pip
pip install --upgrade pip virtualenv

# Account to own server process
useradd -m -d /home/pythonapp pythonapp

# Fetch source code
export HOME=/root
rm -rf /opt/app
git clone https://github.com/eproj-org/test-exe-Igenius.git /opt/app

# Python environment setup
virtualenv -p python3 /opt/app/env
source /opt/app/env/bin/activate
/opt/app/env/bin/pip install google-api-python-client
/opt/app/env/bin/pip install --upgrade oauth2client
/opt/app/env/bin/pip install --upgrade google-cloud-asset
/opt/app/env/bin/pip install -r /opt/app/gce/requirements.txt

# Set ownership to newly created account
chown -R pythonapp:pythonapp /opt/app

# Put supervisor configuration in proper place
cp /opt/app/python-app.conf /etc/supervisor/conf.d/python-app.conf

# Start service via supervisorctl
supervisorctl reread
supervisorctl update
# [END getting_started_gce_startup_script]
