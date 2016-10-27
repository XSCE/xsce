// home.js
// copyright 2016 Tim Moody

// debug

if(typeof debug == 'undefined') {
    debug = false;
}


// constants
var zimVersionIdx = "/common/assets/zim_version_idx.json";
var htmlBaseUrl = "/rachel/modules/";
var apkBaseUrl = "/content/apk/";
var defDir = '/common/menu-defs/';

var host = 'http://' + window.location.hostname;
var menuHtml = "";
var menuDefs = {};
var zimVersions = {};

var scaffold = $.Deferred();
var i;

// get name to instance index for zim files
var getZimVersions = $.getJSON(zimVersionIdx)
  	.done(function( data ) {
  		//consoleLog(data);
  	zimVersions = data;})
  	.fail(jsonErrhandler);

$.when(scaffold, getZimVersions).then(procMenu);

// create scaffolding for menu items
var html = "";
for (i = 0; i < menuItems.length; i++) {
	var menu_item_name = menuItems[i];
	menuDefs[menu_item_name] = {}
	menuItemDivId = i.toString() + "-" + menu_item_name;
	menuDefs[menu_item_name]['menu_id'] = menuItemDivId;

	html += '<div id="' + menuItemDivId + '" class="content-item" dir="auto">&emsp;Attempting to load ' + menu_item_name + ' </div>';
}
$("#content").html(html);
scaffold.resolve();

function procMenu() {
	var menuItem;

	for (var i = 0; i < menuItems.length; i++) {
		menuItem = menuItems[i];
		consoleLog(menuItem);
		$.getJSON(defDir + menuItems[i] + '.json')
		.done(procMenuItem)
		.fail(jsonErrhandler);
	}
}

function procMenuItem(data) {
	var module;
	var menuItem;
  var menuHtml = "";
	var menu_item_name = data['menu_item_name'];
	menuItem = menu_item_name;
	var menuId = menuDefs[menu_item_name]['menu_id'];
	var menuItemDivId = "#" + menuId;

	menuDefs[menu_item_name] = data;
	menuDefs[menu_item_name]['add_html'] = ""; //})
	menuDefs[menu_item_name]['menu_id'] = menuId;

	if (menuItem in  menuDefs){
		module = menuDefs[menuItem];
		consoleLog(module);
		if (module['intended_use'] == "zim")
		  menuHtml += calcZimLink(module);
		else if (module['intended_use'] == "html")
			menuHtml += calcHtmlLink(module);
		else if (module['intended_use'] == "kalite")
			menuHtml += calcKaliteLink(module);
		else if (module['intended_use'] == "osm")
			menuHtml += calcOsmLink(module);
		else
			menuHtml += '<div class="content-item" style="padding:10px; color: red; font-size: 1.5em">' +  menuItem + ' - unknown module type</div>';
		}
	else{
		menuHtml += '<div class="content-item" style="padding:10px; color: red; font-size: 1.5em">' + menuItem + ' - file not found or improperly formatted</div>';
	}

	$(menuItemDivId).html(menuHtml);
	getExtraHtml(module);
}

function calcZimLink(module){
	var href = host + ':3000/' + zimVersions[module.zim_name] + '/';

	var html = calcLink(href,module);
	return html
}

function calcHtmlLink(module){
	var href = htmlBaseUrl + module.moddir;

	var html = calcLink(href,module);
	return html
}

function calcKaliteLink(module){
	var href = host + ':8008';

	var html = calcLink(href,module);
	return html
}

function calcOsmLink(module){
	var href = '/iiab/static/map.html';

	var html = calcLink(href,module);
	return html
}

function calcLink(href,module){
	var startPage = href;

	// record href for extra html
	menuDefs[module.menu_item_name]['href'] = href;

	if (module.hasOwnProperty("start_url"))
	  startPage = href + '/' + module['start_url'];

	var html = '<div style="display: table;"><div style="display: table-row;">';
	html+='<div class="content-icon"><a href="' + startPage + '"><img src="/common/images/' + module.logo_url + '" alt="' + module.title + '"></div>';
	html+='<div class="content-cell">';
	html+='<h2><a href="' + startPage + '">' + module.title + '</a></h2>';
	html+='<p>' + module.description + '</p>';
	if (module.hasOwnProperty("apk_file"))
	  html+='<p>Click here to download <a href="' + apkBaseUrl + module.apk_file + '">' + module.apk_file + '</a></p>';
	consoleLog('href = ' + href);
	html += '<div id="' + module.menu_id + '-htmlf"></div>'; // scaffold for extra html
	html+='</div></div></div>';

	return html
}

function getExtraHtml(module) {
	if (module.hasOwnProperty("extra_html") && (module['extra_html'] != "")){
		consoleLog('starting get extra');
		consoleLog(module.extra_html);
		var resp = $.ajax({
			type: 'GET',
			async: true,
			url: defDir + module.extra_html,
			dataType: 'html'
		})
		.done(function( data ) {
			//menuDefs[module.menu_item_name]['add_html'] = data;
			consoleLog('in get extra done');
			var add_html = data;
	    var re = new RegExp('##HREF-BASE##', 'g');
	    add_html = add_html.replace(re, module.href);
	    menuItemHtmlfDivId = "#" + module.menu_id + '-htmlf';
	    consoleLog(menuItemHtmlfDivId);
	    $(menuItemHtmlfDivId).html(add_html);
		});
		//.fail(jsonErrhandler);
		return resp;
	}
}

function jsonErrhandler (jqXHR, textStatus, errorThrown)
{
	// only handle json parse errors here, others in ajaxErrHandler
	//  if (textStatus == "parserror") {
	//    //alert ("Json Errhandler: " + textStatus + ", " + errorThrown);
	//    displayServerCommandStatus("Json Errhandler: " + textStatus + ", " + errorThrown);
	//  }
	consoleLog("In Error Handler logging jqXHR");
	consoleLog(textStatus);
	consoleLog(errorThrown);
	consoleLog(jqXHR);

	return false;
}

function consoleLog (msg)
{
	if (debug == true)
	  console.log(msg); // for IE there can be no console messages unless in tools mode
}
