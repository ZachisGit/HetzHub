function _load_tfstate_resources() {
    let tfstate_string = localStorage.getItem("tfstate");
    var tfstate = JSON.parse(tfstate_string);

    return tfstate.resources;
}

function get_service_list() {
    let resources = _load_tfstate_resources();
    let services = {};
    let services_list = [];

    resources.forEach(resource => {
        if (resource.module){
            if(!services[resource.module]){
                services[resource.module] = {};
            }

            if (resource.type == "template_file"){
                services[resource.module][resource.name] = resource["instances"][0]["attributes"]["rendered"];
            } 
        }
    });

    Object.entries(services).forEach(([key, value]) => {
        if (value["service-id"] != "config"){
            services_list.push({"name": key, "service": value});
        }
    });

    return services_list;
}

function get_service_by_index(index) {
    return get_service_list()[index];
}