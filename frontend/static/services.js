var active_service = -1;

$(function() {
    
    /*
    $('.sidebar').on( "click",function(e) {
        $('.sidebar').toggleClass('collapsed');
    });
    */

    load_services();

    let hash_split = window.location.href.split("#");
    console.log(hash_split.length-1);
    if (hash_split.length == 1 || hash_split[hash_split.length-1] == "") {
        window.location.href = window.location.href+"#0";
    }

    on_active_service_change();    
    $(window).on('hashchange', on_active_service_change);
    
});


function load_services() {
    
    let services = get_service_list();
    let container = $('.nav');

    let index = 0; 
    services.forEach(function(service) {
        let li = $('<li>').addClass('nav-item service')
        let a = $('<a>').addClass('nav-link text-white').attr('href', '#'+index).text(service.name);

        li.append(a);
        container.append(li);
        index++;
    });
}

function on_active_service_change() {
    let index = parseInt(window.location.hash.substring(1));
    let services = document.getElementsByClassName("service");

    if (!services || services.length == 0) {
        load_preview(-1);
        return;
    }

    for (let i = 0; i < services.length; i++) {
        services[i].classList.remove("bg-dark");
    }
    services[index].classList.add("bg-dark");
    
    active_service = index;
    console.log(services[index].getElementsByTagName("a")[0].innerText)
    load_preview(active_service);
}

function load_preview(index) {

    let service = get_service_by_index(index);  // Null if index is out of bounds
    if (service == null) {
        _choose_service_preview();
        return;
    }

    let name = service.name;
    let resources = service.service;
    switch (resources["output_service_id"]) {
        case "jupyterlab":
            _load_jupyterlab_preview(resources);
            break;
        case "s3":
            _load_s3_preview(resources);
            break; 
        default:
            _choose_service_preview();
            break;
    };
    // $('.preview-container').append($("<button>").addClass("btn btn-primary").text("Deploy").click(function() {}));
}

function _load_jupyterlab_preview(service) {
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("Jupyterlab"));  
    $('.preview-container').append($('<br>'));

    let table = $('<table>').addClass('table table-striped');
    let tbody = $('<tbody>');
    table.append(tbody);
    $('.preview-container').append(table);
        
    // Inputs
    let tr_app_name = $('<tr>');
    tr_app_name.append($('<td>').text('App Name'));
    tr_app_name.append($('<th>').text(service["input_app_name"]));
    tbody.append(tr_app_name);

    let tr_region = $('<tr>');
    tr_region.append($('<td>').text('Region'));
    tr_region.append($('<th>').text(service["input_region"]));
    tbody.append(tr_region);

    let tr_instance_type = $('<tr>'); 
    tr_instance_type.append($('<td>').text('Instance Type'));
    tr_instance_type.append($('<th>').text(service["input_instance_type"]));
    tbody.append(tr_instance_type);

    let tr_enable_backups = $('<tr>');
    tr_enable_backups.append($('<td>').text('Enable Backups'));
    tr_enable_backups.append($('<th>').text(service["input_enable_backups"]));
    tbody.append(tr_enable_backups);

    let tr_delete_protection = $('<tr>');
    tr_delete_protection.append($('<td>').text('Delete Protection'));
    tr_delete_protection.append($('<th>').text(service["input_delete_protection"]));
    tbody.append(tr_delete_protection);

    // Outputs
    let tr_endpoint = $('<tr>');
    tr_endpoint.append($('<td>').text('Endpoint'));
    tr_endpoint.append($('<th>').append($('<a>').attr('href', service["output_endpoint"]).text(service["output_endpoint"]).attr('target', '_blank')));
    tbody.append(tr_endpoint);

    let tr_node_ip = $('<tr>');
    tr_node_ip.append($('<td>').text('IPv4'));
    tr_node_ip.append($('<th>').text(service["output_node_ip"]));
    tbody.append(tr_node_ip);

    let tr_access_token = $('<tr>');
    tr_access_token.append($('<td>').text('Access Token'));
    tr_access_token.append($('<th>').text(service["output_access_token"]));
    tbody.append(tr_access_token);
    
    let submit_button = $('<button>').addClass('btn btn-primary').text('Configure').on("click",function(e) {
        e.preventDefault();
        _apply_jupyterlab_preview(service);
    });
    $('.preview-container').append($('<br>'));
    $('.preview-container').append($('<br>'));
    $('.preview-container').append($('<hr>'));
    $('.preview-container').append(submit_button);
}

function _load_s3_preview(service) {
   
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("Minio S3"));  
    $('.preview-container').append($('<br>'));  

    let table = $('<table>').addClass('table table-striped pe-5');
    let tbody = $('<tbody>');
    table.append(tbody);
    $('.preview-container').append(table);
    
    // Inputs
    let tr_app_name = $('<tr>');
    tr_app_name.append($('<td>').text('App Name'));
    tr_app_name.append($('<th>').text(service["input_app_name"]));
    tbody.append(tr_app_name);

    let tr_region = $('<tr>');
    tr_region.append($('<td>').text('Region'));
    tr_region.append($('<th>').text(service["input_region"]));
    tbody.append(tr_region);

    let tr_instance_type = $('<tr>'); 
    tr_instance_type.append($('<td>').text('Instance Type'));
    tr_instance_type.append($('<th>').text(service["input_instance_type"]));
    tbody.append(tr_instance_type);

    let tr_volume_size = $('<tr>');
    tr_volume_size.append($('<td>').text('Volume Size'));
    tr_volume_size.append($('<th>').text(service["input_volume_size"]));
    tbody.append(tr_volume_size);

    let tr_enable_backups = $('<tr>');
    tr_enable_backups.append($('<td>').text('Enable Backups'));
    tr_enable_backups.append($('<th>').text(service["input_enable_backups"]));
    tbody.append(tr_enable_backups);

    let tr_delete_protection = $('<tr>');
    tr_delete_protection.append($('<td>').text('Delete Protection'));
    tr_delete_protection.append($('<th>').text(service["input_delete_protection"]));
    tbody.append(tr_delete_protection);

    // Outputs
    let tr_endpoint = $('<tr>');
    tr_endpoint.append($('<td>').text('Endpoint'));
    tr_endpoint.append($('<th>').append($('<a>').attr('href', service["output_endpoint"]).text(service["output_endpoint"]).attr('target', '_blank')));
    tbody.append(tr_endpoint);

    let tr_node_ip = $('<tr>');
    tr_node_ip.append($('<td>').text('IPv4'));
    tr_node_ip.append($('<th>').text(service["output_node_ip"]));
    tbody.append(tr_node_ip);

    let tr_user_name = $('<tr>');
    tr_user_name.append($('<td>').text('Access Key'));
    tr_user_name.append($('<th>').text("admin"));
    tbody.append(tr_user_name);

    let tr_access_token = $('<tr>');
    tr_access_token.append($('<td>').text('Secret Key'));
    tr_access_token.append($('<th>').text(service["output_secret_key"]));
    tbody.append(tr_access_token);
    
    let submit_button = $('<button>').addClass('btn btn-primary').text('Configure').on("click",function(e) {
        e.preventDefault();
        _apply_s3_preview(service);
    });
    $('.preview-container').append($('<br>'));
    $('.preview-container').append($('<br>'));
    $('.preview-container').append($('<hr>'));
    $('.preview-container').append(submit_button);
}

function _apply_jupyterlab_preview(service) {
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("Jupyterlab"));  
    $('.preview-container').append($('<br>'));

    let form = $('<form>').addClass('form');
    // set form labels to bold and make them white
    // make them even bigger than the default
    form.append($('<style>').text('label { font-weight: bold; font-size: 1.2em; }'));
    $('.preview-container').append(form);

        
    // Inputs

    // App Name
    let input_app_name_form_group = $('<div>').addClass('form-group');
    let input_app_name_label = $('<label>').text('App Name');
    let input_app_name = $('<input>').attr('type', 'text').attr('name', 'input_app_name').attr('value', service["input_app_name"]).attr("class", "medium-select");
    input_app_name_form_group.append(input_app_name_label);
    input_app_name_form_group.append($('<br>'));
    input_app_name_form_group.append(input_app_name);

    if (service["input_app_name"]) {
        input_app_name_form_group.prop('disabled', true);
    }
    form.append(input_app_name_form_group);
    form.append($('<br>'));


    // Region
    let input_region_form_group = $('<div>').addClass('form-group');
    let input_region_label = $('<label>').text('Region');
    let input_region = $('<select>').attr('name', 'region').attr("class", "medium-select");

    REGIONS.regions.forEach(function(region) {
        input_region.append($('<option>').attr('value', region["id"]).text(region["name"]));
    });
    input_region.attr('value', service["input_region"]);
    let region_index = REGIONS.regions.indexOf(REGIONS.regions.find(region => region.id == service["input_region"]));
    input_region.prop('selectedIndex', region_index);

    input_region_form_group.append(input_region_label);
    input_region_form_group.append($('<br>'));
    input_region_form_group.append(input_region);
    form.append(input_region_form_group);
    form.append($('<br>'));

    
    // Instance Type
    let input_instance_type_form_group = $('<div>').addClass('form-group');
    let input_instance_type_label = $('<label>').text('Instance Type');
    let input_instance_type = $('<select>').attr('name', 'input_instance_type').attr('value', service["input_instance_type"]).attr("class", "medium-select");

    SERVER_TYPES.servers.forEach(function(instance_type) {
        input_instance_type.append($('<option>').attr('value', instance_type["name"]).text(instance_type["description"] + " - " + instance_type["cores"]+" cores, "+instance_type["memory"]+" GB RAM" + ", " + instance_type["disk"]+" GB storage"));
    });
    
    let instance_index = SERVER_TYPES.servers.indexOf(SERVER_TYPES.servers.find(instance => instance.name == service["input_instance_type"]));
    input_region.prop('selectedIndex', region_index);

    input_instance_type_form_group.append(input_instance_type_label);
    input_instance_type_form_group.append($('<br>'));
    input_instance_type_form_group.append(input_instance_type);
    form.append(input_instance_type_form_group);
    form.append($('<br>'));

    // Enable Backups
    let input_enable_backups = $('<input>').attr('type', 'checkbox').attr('name', 'input_enable_backups').prop('checked', service["input_enable_backups"] == "true");
    form.append($('<label>').text('Enable Backups'));
    form.append($('<br>'));
    form.append(input_enable_backups);
    form.append($('<br>'));
    form.append($('<br>'));

    // Delete Protection
    let input_delete_protection = $('<input>').attr('type', 'checkbox').attr('name', 'input_delete_protection').prop('checked', service["input_delete_protection"] == "true");;
    form.append($('<label>').text('Delete Protection'));
    form.append($('<br>'));
    form.append(input_delete_protection);

    // Make the check boxes a toggle switch and name them on and off
    input_enable_backups.bootstrapToggle({ 
        on: 'On', 
        off: 'Off', 
        onstyle: 'success', // Set the color for the "On" state
        offstyle: 'secondary', // Set the color for the "Off" state
        size: 'normal', // Set the size of the toggle switch
        disabled: false, // Disable the toggle switch
    });
    
    input_delete_protection.bootstrapToggle({ 
        on: 'On', 
        off: 'Off', 
        onstyle: 'success', // Set the color for the "On" state
        offstyle: 'secondary', // Set the color for the "Off" state
        size: 'normal', // Set the size of the toggle switch
        disabled: false // Disable the toggle switch
    });

    let submit_button = $('<button>').addClass('btn btn-primary').text('Deploy').on("click",function(e) {
        e.preventDefault();

        // Get the form data
        let form_data = $(this).closest('form').serializeArray();
        let data = {};
        form_data.forEach(function(input) {
            data[input.name] = input.value;
        });

        // Create provisioning plan component (provisioning plan is a list of dicts)
        let prov_dict = {"output_service_id": service["output_service_id"] };   // Important: output_service_id is required for the provisioning plan
        prov_dict["input_app_name"] = data["input_app_name"];
        prov_dict["input_region"] = data["region"]; 
        prov_dict["input_instance_type"] = data["input_instance_type"]; 
        prov_dict["input_enable_backups"] = data["input_enable_backups"] == "on" ? true : false;
        prov_dict["input_delete_protection"] = data["input_delete_protection"] == "on" ? true : false;

        // Deploy
        deploy_service(prov_dict);
    });
    form.append($('<br>'));
    form.append($('<hr>'));
    form.append(submit_button);
}

function _apply_s3_preview(service) {
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("Minio S3"));  
    $('.preview-container').append($('<br>'));

    let form = $('<form>').addClass('form');
    // set form labels to bold and make them white
    // make them even bigger than the default
    form.append($('<style>').text('label { font-weight: bold; font-size: 1.2em; }'));
    $('.preview-container').append(form);

        
    // Inputs

    // App Name
    let input_app_name_form_group = $('<div>').addClass('form-group');
    let input_app_name_label = $('<label>').text('App Name');
    let input_app_name = $('<input>').attr('type', 'text').attr('name', 'input_app_name').attr('value', service["input_app_name"]).attr("class", "medium-select");
    input_app_name_form_group.append(input_app_name_label);
    input_app_name_form_group.append($('<br>'));
    input_app_name_form_group.append(input_app_name);

    if (service["input_app_name"]) {
        input_app_name_form_group.prop('disabled', true);
    }
    form.append(input_app_name_form_group);
    form.append($('<br>'));


    // Region
    let input_region_form_group = $('<div>').addClass('form-group');
    let input_region_label = $('<label>').text('Region');
    let input_region = $('<select>').attr('name', 'region').attr("class", "medium-select");

    REGIONS.regions.forEach(function(region) {
        input_region.append($('<option>').attr('value', region["id"]).text(region["name"]));
    });
    input_region.attr('value', service["input_region"]);
    let region_index = REGIONS.regions.indexOf(REGIONS.regions.find(region => region.id == service["input_region"]));
    input_region.prop('selectedIndex', region_index);

    input_region_form_group.append(input_region_label);
    input_region_form_group.append($('<br>'));
    input_region_form_group.append(input_region);
    form.append(input_region_form_group);
    form.append($('<br>'));

    
    // Instance Type
    let input_instance_type_form_group = $('<div>').addClass('form-group');
    let input_instance_type_label = $('<label>').text('Instance Type');
    let input_instance_type = $('<select>').attr('name', 'input_instance_type').attr('value', service["input_instance_type"]).attr("class", "medium-select");

    SERVER_TYPES.servers.forEach(function(instance_type) {
        input_instance_type.append($('<option>').attr('value', instance_type["name"]).text(instance_type["description"] + " - " + instance_type["cores"]+" cores, "+instance_type["memory"]+" GB RAM" + ", " + instance_type["disk"]+" GB storage"));
    });
    
    let instance_index = SERVER_TYPES.servers.indexOf(SERVER_TYPES.servers.find(instance => instance.name == service["input_instance_type"]));
    input_region.prop('selectedIndex', region_index);

    input_instance_type_form_group.append(input_instance_type_label);
    input_instance_type_form_group.append($('<br>'));
    input_instance_type_form_group.append(input_instance_type);
    form.append(input_instance_type_form_group);
    form.append($('<br>'));

    // Volume Size
    let input_volume_size_form_group = $('<div>').addClass('form-group');
    let input_volume_size_label = $('<label>').text('Volume Size (in GB)');
    let input_volume_size = $('<input>').attr('type', 'number').attr('name', 'input_volume_size').attr('value', service["input_volume_size"]);
    input_volume_size_form_group.append(input_volume_size_label);
    input_volume_size_form_group.append($('<br>'));
    input_volume_size_form_group.append(input_volume_size);
    form.append(input_volume_size_form_group);
    form.append($('<br>'));


    // Enable Backups
    let input_enable_backups = $('<input>').attr('type', 'checkbox').attr('name', 'input_enable_backups').prop('checked', service["input_enable_backups"] == "true");
    form.append($('<label>').text('Enable Backups'));
    form.append($('<br>'));
    form.append(input_enable_backups);
    form.append($('<br>'));
    form.append($('<br>'));

    // Delete Protection
    let input_delete_protection = $('<input>').attr('type', 'checkbox').attr('name', 'input_delete_protection').prop('checked', service["input_delete_protection"] == "true");;
    form.append($('<label>').text('Delete Protection'));
    form.append($('<br>'));
    form.append(input_delete_protection);
    form.append($('<br>'));

    // Make the check boxes a toggle switch and name them on and off
    input_enable_backups.bootstrapToggle({ 
        on: 'On', 
        off: 'Off', 
        onstyle: 'success', // Set the color for the "On" state
        offstyle: 'secondary', // Set the color for the "Off" state
        size: 'normal', // Set the size of the toggle switch
        disabled: false, // Disable the toggle switch
    });
    
    input_delete_protection.bootstrapToggle({ 
        on: 'On', 
        off: 'Off', 
        onstyle: 'success', // Set the color for the "On" state
        offstyle: 'secondary', // Set the color for the "Off" state
        size: 'normal', // Set the size of the toggle switch
        disabled: false // Disable the toggle switch
    });

    let submit_button = $('<button>').addClass('btn btn-primary').text('Deploy').on("click",function(e) {
        e.preventDefault();

        // Get the form data
        let form_data = $(this).closest('form').serializeArray();
        let data = {};
        form_data.forEach(function(input) {
            data[input.name] = input.value;
        });

        // Create provisioning plan component (provisioning plan is a list of dicts)
        let prov_dict = {"output_service_id": service["output_service_id"] };   // Important: output_service_id is required for the provisioning plan
        prov_dict["input_app_name"] = data["input_app_name"];
        prov_dict["input_region"] = data["region"]; 
        prov_dict["input_instance_type"] = data["input_instance_type"];
        prov_dict["input_volume_size"] = data["input_volume_size"].toString();
        prov_dict["input_enable_backups"] = data["input_enable_backups"] == "on" ? "true" : "false";
        prov_dict["input_delete_protection"] = data["input_delete_protection"] == "on" ? "true" : "false";

        // Deploy
        deploy_service(prov_dict);
    });
    form.append($('<br>'));
    form.append($('<hr>'));
    form.append(submit_button);
}

function _choose_service_preview() {
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("Setup a new Service"));  
    $('.preview-container').append($('<br>'));

    let form = $('<form>').addClass('form');
    // set form labels to bold and make them white
    // make them even bigger than the default
    form.append($('<style>').text('label { font-weight: bold; font-size: 1.2em; }'));
    $('.preview-container').append(form);

        
    // Inputs

    // Services list
    let services_list_form_group = $('<div>').addClass('form-group');
    let services_list_label = $('<label>').text('Services');
    let services_list = $('<select>').attr('name', 'services_list').attr("class", "large-select");

    SERVICES_LIST.services.forEach(function(service) {
        services_list.append($('<option>').attr('value', service["id"]).text(service["name"]));
    });
    

    services_list_form_group.append(services_list_label);
    services_list_form_group.append($('<br>'));
    services_list_form_group.append(services_list);
    form.append(services_list_form_group);

    let submit_button = $('<button>').addClass('btn btn-primary').text('Next').on("click",function(e) {
        e.preventDefault();

        // Get the form data
        let form_data = $(this).closest('form').serializeArray();
        let data = {};
        form_data.forEach(function(input) {
            data[input.name] = input.value;
        });

        switch (data["services_list"]) {
            case "jupyterlab":
                _apply_jupyterlab_preview({"output_service_id": data["services_list"]});
                break;
            case "s3":
                _apply_s3_preview({"output_service_id": data["services_list"]});
                break; 
            default:
                $('.preview-container').empty();
                $('.preview-container').append($('<h2>').text("No preview available for " + input.name));
                break;
        };
    });
    form.append($('<hr>'));
    form.append(submit_button);

}