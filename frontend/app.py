# Python Flask app for HetHub (aws like) cloud platform for orchistrating your own Hetzner resources (servers, volumes, etc.) into aws like cloud services. 
# This is the configuration and overview page for the Jupyterlab HetHub service. 
# Page Setup:
# - HetHub Nagivation Bar (top)
# - HetHub Jupyterlab Service Instance list (middle)
#   - Colapsable configuration panel (as expanding Instance colapsable panel)
#     - Instance name
#     - Endpoint (https://12.34.56.78:443/lab)
#     - Instance status (running, stopped, etc.)
#     - Hetzner node type (cx11, cx21, etc.)
#     - Hetzner node location (fsn1, nbg1, etc.)
#     - Expose to internet (yes/no)
#     - Use https (nginx) (yes/no) 
# - Service components list (jupyterlab, volumes, backups, etc.) etc (left side panel)


# Import libraries
from flask import Flask, render_template, jsonify, request

app = Flask(__name__)

# Example configuration data
configs = {
    "service1": {
        "settings": [
            {"name": "Instance Type", "type": "dropdown", "options": ["t2.micro", "t2.small"]},
            # ... other settings
        ]
    },
    "service2": {
        "settings": [
            {"name": "Memory", "type": "number"},
            # ... other settings
        ]
    }
    # ... other services
}

@app.route('/')
def index():
    return render_template('index.html', services=configs.keys())

@app.route('/get-config/<service>')
def get_config(service):
    return jsonify(configs.get(service, {}))

@app.route('/apply-config', methods=['POST'])
def apply_config():
    # Process the submitted configuration
    # For example: print(request.form)
    return "Configuration Applied"

if __name__ == '__main__':
    app.run(debug=True)

