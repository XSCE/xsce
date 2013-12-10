/* Look for Internet-in-a-Box */
/* If found hide searching text and display link */

var xmlhttp = new XMLHttpRequest();
xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
        document.getElementById("iiab-link").style.display = "block";
        document.getElementById("iiab-search").style.display = "none";
    }
}
xmlhttp.open("GET","/iiab/detect",true);
xmlhttp.send();
