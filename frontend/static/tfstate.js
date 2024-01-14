function _load_tfstate_resources() {
    let tfstate_string = localStorage.getItem("tfstate");
    var tfstate = JSON.parse(tfstate_string);

    return !tfstate ? [] : tfstate.resources;
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
    let services = get_service_list();
    return index >= 0 && index < services.length ? services[index] : null;
}

function get_service_by_name(name) {
    let services = get_service_list();
    let service = null;

    services.forEach(element => {
        if (element.service.input_app_name == name){
            service = element;
        }
    });

    return service;
}

function get_service_index_by_name(app_name) {
    for (const [i,service] of Object.entries(get_service_list())) {
        console.log(service.service["input_app_name"] + " == " + app_name);
        if (service.service["input_app_name"] == app_name){
            return i;
        }
    }
    return null;
}

// HetzHub rest endpoint compatible list of dicts
function get_state_plan() {
    let services = get_service_list();
    let full_state = [];

    services.forEach(service => {
        full_state.push(service.service);
    });

    return full_state;
}

function get_provisioning_plan() {
    let prov_plan = [];
    get_state_plan().forEach(service => {
        let prov_dict = {"output_service_id": service["output_service_id"] };
        console.log(service);
        for (const [key, value] of Object.entries(service)) {
            if (key.startsWith("input_")) {
                prov_dict[key] = value;
            }
        }
        prov_plan.push(prov_dict);
    });
    return prov_plan;
}

function deploy_service(prov_dict) {
    console.log(get_service_list());
    if (!prov_dict["output_service_id"]) {
        console.log("No service id provided (missing output_service_id)!");
        return;
    }


    let prov_plan = get_provisioning_plan();
    console.log(prov_plan);

    // New service
    console.log("Input-app-name: " + get_service_by_name(prov_dict["input_app_name"]));
    if (get_service_by_name(prov_dict["input_app_name"]) == null) {
        prov_plan.push(prov_dict);
    }
    // Existing service
    else {
        prov_plan[get_service_index_by_name(prov_dict["input_app_name"])] = prov_dict;
    }

    console.log(prov_plan);
    // TODO: Deploy to Hetzner
}