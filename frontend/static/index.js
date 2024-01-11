document.addEventListener('DOMContentLoaded', function() {
    var fileDropArea = document.querySelector('.file-drop-area');
    var fileInput = fileDropArea.querySelector('.file-input');

    // Highlight drop area when item is dragged over it
    fileDropArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        fileDropArea.classList.add('active');
    });

    // Back to normal state when dragged out
    fileDropArea.addEventListener('dragleave', function() {
        fileDropArea.classList.remove('active');
    });

    // Handling the drop
    function fileDropArea_onDrop(e) {
        e.preventDefault();
        fileDropArea.classList.remove('active');
        // If dropped items aren't files, reject them
        var dt = e.dataTransfer ? e.dataTransfer : e.target;
        if (dt.files && dt.files.length) {
            fileInput.files = dt.files;
            
            var reader = new FileReader();
            reader.onload = function(e) {
                console.log("Got here");
                localStorage.setItem('tfstate', e.target.result);
                window.location.href = "/services";
            };
            reader.readAsText(dt.files[0]);
        }
    }

    fileDropArea.addEventListener('drop', fileDropArea_onDrop);

    // Opening file selector when area is clicked
    fileDropArea.addEventListener('click', function(e) {
        fileInput.click();
    });

    fileDropArea.addEventListener('change', function(e) {
        if (e.target.files[0])
            fileDropArea_onDrop(e);
    });
});