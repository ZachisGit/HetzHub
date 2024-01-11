var active_service = -1;

$(function() {
    load_services();

    let hash_split = window.location.href.split("#");
    console.log(hash_split.length-1);
    if (hash_split.length == 1) {
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
    for (let i = 0; i < services.length; i++) {
        services[i].classList.remove("bg-dark");
    }
    services[index].classList.add("bg-dark");
    
    active_service = index;
    console.log(services[index].getElementsByTagName("a")[0].innerText)
    load_preview(active_service);
}

function load_preview(index) {

    let service = get_service_by_index(index);
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
            $('.preview-container').empty();
            $('.preview-container').append($('<h2>').text("No preview available for " + name));
            break;
    };
}

function _load_jupyterlab_preview(service) {
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("Jupyterlab"));  
    $('.preview-container').append($('<br>'));

    let table = $('<table>').addClass('table table-striped table-dark');
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
    tr_endpoint.append($('<th>').text(service["output_endpoint"]));
    tbody.append(tr_endpoint);

    let tr_node_ip = $('<tr>');
    tr_node_ip.append($('<td>').text('IPv4'));
    tr_node_ip.append($('<th>').text(service["output_node_ip"]));
    tbody.append(tr_node_ip);

    let tr_access_token = $('<tr>');
    tr_access_token.append($('<td>').text('Access Token'));
    tr_access_token.append($('<th>').text(service["output_access_token"]));
    tbody.append(tr_access_token);


}

function _load_s3_preview(service) {
   
    $('.preview-container').empty();
    $('.preview-container').append($('<h2>').text("S3 - Minio Server"));  
    $('.preview-container').append($('<br>'));  

    let table = $('<table>').addClass('table table-striped table-dark');
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
    tr_endpoint.append($('<th>').text(service["output_endpoint"]));
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
}
    