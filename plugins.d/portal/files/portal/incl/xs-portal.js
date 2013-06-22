/* Look for Internet-in-a-Box and display link if found */

var xmlhttp = new XMLHttpRequest();
xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
        document.getElementById("iiab-link").style.display = "block";
    }
}
xmlhttp.open("GET","/iiab/detect",true);
xmlhttp.send();
