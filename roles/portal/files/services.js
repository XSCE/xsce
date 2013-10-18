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
        for(var service in servicelinks) {
            srv = servicelinks[service]
            port = srv.port ? ":"+srv.port : ""
            url = "//" + location.hostname + port + srv.path
            serviceList += "<div class='service'>"
            serviceList += "<a href='" + url + "'>" + srv.name + "</a>"
            serviceList += "<div class='desc'>" + srv.description + "</div>"
            serviceList += "</div>"
        }
        document.getElementById("servicelist").innerHTML=serviceList
    });
}
