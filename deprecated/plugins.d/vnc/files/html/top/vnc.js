// JavaScript Document
//<script language="JavaScript" type="text/JavaScript">	
//var vncwin = object;
function popvnc(){
	var x = 0, y = 0; // default values
	if (! parent.vncwin) {
		if (navigator.appName=="Netscape")
		{
			x = window.screenX - 100;
			y = window.screenY + 100;
		}
		else if (navigator.appName.indexOf("Microsoft")!=-1)
		{
			x = window.screenLeft + 100;
			y = window.screenTop + 100;
		}
		var param='dialog, modal, toolbar=no, status=no, scrollbars=no, resizable=no, width=800, height=600 , left='+x+', top='+y+', location=no';
		parent.vncwin = window.open('/novnc/vnc_auto.html?HOST=172.18.96.1&port=6080&encrypt=1&true_color=1','School Server',param); 
		//parent.vncwin = window.open('/novnc/vnc_auto.html?HOST=172.18.96.1&port=6080&true_color=1','School Server',param); -->
		parent.vncwin.focus();
		return false;
	} else {
		parent.vncwin.focus();
		return false;
	}
}
function peervnc(){
	if (! parent.vncwin || parent.vncwin.closed) {
		var param='dialog,modal,target=_tab,toolbar=no,status=no,scrollbars=no,resizable=no,width=800,height=600,location=no';
		parent.vncwin = window.open('/novnc/vnc_auto.html?HOST=172.18.96.1&port=6080&true_color=1','_blank',param); 
		vncwin.focus();
		test = "initialized";
		return true;
	} else {
		//alert("focus");
		parent.vncwin.focus();
		return false;
	}
}
//</script>
