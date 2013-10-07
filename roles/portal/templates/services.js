function loadJSONservices(path, callback) {
    var httpRequest = new XMLHttpRequest();
    httpRequest.onreadystatechange = function() {
        if (httpRequest.readyState === 4) {
            if (httpRequest.status === 200) {
                var data = JSON.parse(httpRequest.responseText);
                    if (callback) callback(data);
                }
            }
        };
    httpRequest.open('GET', path);
    httpRequest.send();
}
function loadServices(){
    loadJSONservices('services.json', function(servicelinks){
        var serviceList ="";
        for(i=0;i<servicelinks.length;i++){
            serviceList += "<div class='service'>"+"<a href="+servicelinks[i].link+">"+servicelinks[i].name+"</a>"+"<div id='desc'>"+servicelinks[i].description+"</div>"+"</div>";
        }
        document.getElementById("servicelist").innerHTML=serviceList
    });
}
