var active_service = -1;

$(function() {
    on_active_service_change(0);
});

function on_active_service_change(index) {
    let services = document.getElementsByClassName("service");
    for (let i = 0; i < services.length; i++) {
        services[i].classList.remove("bg-dark");
    }
    services[index].classList.add("bg-dark");
    
    active_service = index;
    console.log(services[index].getElementsByTagName("a")[0].innerText)
    loadConfig(services[index].getElementsByTagName("a")[0].innerText);
}

function loadConfig(service) {
    $.getJSON('/get-config/' + service, function(data) {
        var form = $('#configForm .form-content');
        form.empty();
        data.settings.forEach(function(setting) {
            var input;
            if (setting.type === 'dropdown') {
                input = $('<select>').attr('name', setting.name);
                setting.options.forEach(function(option) {
                    input.append($('<option>').text(option));
                });
            } else if (setting.type === 'number') {
                input = $('<input>').attr('type', 'number').attr('name', setting.name);
            } else if (setting.type === 'checkbox') {
                input = $('<input>').attr('type', 'checkbox').attr('name', setting.name);
            }
            form.append($('<label>').text(setting.name), input, $('<br>'));
        });
    });
}