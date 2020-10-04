# Copyright 2019 Google LLC All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from google.cloud import asset_v1p5beta1

from googleapiclient import discovery
from oauth2client.client import GoogleCredentials
from pprint import pprint

from flask import Flask, request
app = Flask(__name__)


@app.route('/compute.list', methods=['GET'])
def list_compute():
    credentials = GoogleCredentials.get_application_default()

    service = discovery.build('compute', 'v1', credentials=credentials)

    # Project ID for this request.
    project_name = request.args.get('project')

    # The name of the zone for this request.
    zone_name = request.args.get('zone')

    request_api= service.instances().list(project=project_name, zone=zone_name)
    all_instances = []
    while request_api is not None:
        response = request_api.execute()

        for instance in response['items']:
            all_instances.append(instance)
            pprint(instance)
            print('#################################################################')

        request_api = service.instances().list_next(previous_request=request, previous_response=response)
    return {'all_instances': all_instances}

def compute_isrunning(par_project,  par_zone, par_instance):
    credentials = GoogleCredentials.get_application_default()

    service = discovery.build('compute', 'v1', credentials=credentials)

    request = service.instances().get(project=par_project, zone=par_zone , instance=par_instance)
        
    response = request.execute()
    pprint(response)
    if response["status"] == 'RUNNING':
        return True


@app.route('/assets.list', methods=['GET'])
def list_assets():
#  project_id = 'Your Google Cloud Project ID'
#  asset_types = 'Your asset type list, e.g.,
# ["storage.googleapis.com/Bucket","bigquery.googleapis.com/Table"]'
#  page_size = 'Num of assets in one page, which must be between 1 and
# 1000 (both inclusively)'

    # The name of the organization for this request.
    parent_arg = request.args.get('parent')

    #project_resource = "projects/{}".format(project_id)
    content_type = asset_v1p5beta1.ContentType.RESOURCE
    client = asset_v1p5beta1.AssetServiceClient()
    
    # Call ListAssets v1p5beta1 to list assets.
    response = client.list_assets(
        request={
            "parent": parent_arg,
            "read_time": None,
            "asset_types": ['compute.googleapis.com.Instance'],
            "content_type": 'CONTENT_TYPE_UNSPECIFIED',
            #"page_size": page_size,
        }
    )
    
    all_zones_with_running_instances = set()
    for asset in response.assets:
        info_list =  asset.name.split('/')
        project = info_list[4]
        zone = info_list[6]
        instance = info_list[8]
        if compute_isrunning(project, zone, instance) == True :
            all_zones_with_running_instances.add(zone)

    ser_set_running = list(all_zones_with_running_instances)
    pprint(ser_set_running)
    return {'all_zones_with_running_instances': ser_set_running} 

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)
