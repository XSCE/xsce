// admin_console.js
// copyright 2015 Tim Moody

var xsceContrDir = "/etc/xsce/";
var consoleJsonDir = "/common/assets/";
var ansibleFacts = {};
var ansibleTagsStr = "";
var effective_vars = {};
var config_vars = {};
var xsce_ini = {};
var job_status = {};
var langCodes = {}; // iso code, local name and English name for all languages we support, read from file
var zimCatalog = {}; // working composite catalog of kiwix, installed, and wip zims
var zimLangs = {}; // working list of iso codes in zimCatalog
var zimGroups = {}; // zim ids grouped by language and category
var kiwixCatalog = {}; // catalog of kiwix zims, read from file downloaded from kiwix.org
var installedZimCat = {}; // catalog of installed, and wip zims

var zimsInstalled = []; // list of zims already installed
var zimsScheduled = []; // list of zims being installed (wip)

var langNames = []; // iso code, local name and English name for languages for which we have zims sorted by English name for language
var topNames = ["ara","eng","spa","fra","hin","por"]; // languages for top language menu
var defaultLang = "eng";
var langGroups = {"en":"eng"}; // language codes to treat as a single code
var selectedLangs = []; // languages selected by gui for display of content
var selectedZims = [];
var sysStorage = {};
sysStorage.zims_selected_size = 0;

// because jquery does not percolate .fail conditions in async chains
// and because an error returned from the server is not an ajax error
// flag must be set to false before use

var globalAjaxErrorFlag = false;

// Set up nav

$("ul.nav a").click(function (e) {
  e.preventDefault();
  $(this).tab('show');
  console.log($(this));
  if ($(this).is('[call-after]')) {
    //if ($this).attr('call-after') !== undefined) {
    console.log($(this).attr('call-after'));
    if ($(this).is('[call-after-arg]'))
    {
      console.log($(this).attr('call-after-arg'));
      window[$(this).attr('call-after')]($(this).attr('call-after-arg'));
    }
    else
      window[$(this).attr('call-after')]();
  }
  else
    console.log(' no call-after');
});

// Get Ansible facts and other data
init();

// BUTTONS

// Control Buttons

$("#REBOOT").click(function(){
  rebootServer();
});

$("#POWEROFF").click(function(){
  poweroffServer();
});


// Configuration Buttons
$("#Bad-CMD").click(function(){
  sendCmdSrvCmd("XXX", testCmdHandler);
});

$("#Test-CMD").click(function(){
  //sendCmdSrvCmd("TEST ;", testCmdHandler);
  getJobStat();
});

$("#List-CMD").click(function(){
  sendCmdSrvCmd("LIST", listCmdHandler);
});

$("#SET-CONF-CMD").click(function(){
  button_feedback("#SET-CONF-CMD", true);
  setConfigVars();
  button_feedback("#SET-CONF-CMD",false);
});

$("#SAVE-WHITELIST").click(function(){
  button_feedback("#SAVE-WHITELIST", true);
  setWhitelist();
  button_feedback("#SAVE-WHITELIST", false);
});

$("#RUN-ANSIBLE").click(function(){
  button_feedback("#RUN-ANSIBLE", true);
  runAnsible("ALL-TAGS");
  //runAnsible("addons");
  button_feedback("#RUN-ANSIBLE", false);
});

$("#RUN-TAGS").click(function(){
  button_feedback("#RUN-TAGS", true);
  tagList = "";
  $('#ansibleTags input').each( function(){
    if (this.type == "checkbox") {
      if (this.checked)
      tagList += this.name + ',';
    }
  });
  if (tagList.length > 0)
  tagList = tagList.substring(0, tagList.length - 1);
  runAnsible(tagList);
  //runAnsible("addons");
  button_feedback("#RUN-TAGS", false);
});

$("#STOP").click(function(){
  sendCmdSrvCmd("STOP", genericCmdHandler);
});

// Install Content Buttons

$("#selectLangButton").click(function(){
  procZimGroups();
  $('#selectLangCodes').modal('hide');
  $('#ZimLanguages2').hide();
  procZimLangs(); // make top menu reflect selections
});

$("#selectLangButton2").click(function(){
  procZimGroups();
  $('#selectLangCodes').modal('hide');
  $('#ZimLanguages2').hide();
  procZimLangs(); // make top menu reflect selections
});

$("#moreLangButton").click(function(){
  $('#ZimLanguages2').show();
});

$("#INST-ZIMS").click(function(){
  var zim_id;
  button_feedback("#INST-ZIMS", true);

  $('#ZimDownload input').each( function(){
    if (this.type == "checkbox")
    if (this.checked){
      zim_id = this.name;
      if (zimsInstalled.indexOf(zim_id) == -1 && zimsScheduled.indexOf(zim_id) == -1)
      instZim(zim_id);
    }
  });
  procZimGroups();
  alert ("Selected Zims scheduled to be installed.\n\nPlease view Utilities->Display Job Status to see the results.");
  button_feedback("#INST-ZIMS", false);
});

$("#launchKaliteButton").click(function(){
  var url = "http://" + window.location.host + ":8008";
  //consoleLog(url);
  window.open(url);
});

$("#ZIM-STATUS-REFRESH").click(function(){
  refreshDiskSpace();
});

$("#RESTART-KIWIX").click(function(){
  restartKiwix();
});

$("#KIWIX-LIB-REFRESH").click(function(){
  getKiwixCatalog();
});

// Util Buttons

$("#JOB-STATUS-REFRESH").click(function(){
	button_feedback("#JOB-STATUS-REFRESH", true);
  getJobStat();
  button_feedback("#JOB-STATUS-REFRESH", false);
});

$("#CANCEL-JOBS").click(function(){
	var cmdList = [];
  button_feedback("#CANCEL-JOBS", true);
  $('#jobStatTable input').each( function(){
    if (this.type == "checkbox")
      if (this.checked){
        job_idArr = this.id.split('-');
        job_id = job_idArr[1];

        // cancelJobFunc returns the function to call not the result as needed by array.push()
        cmdList.push(cancelJobFunc(job_id));
        if (job_status[job_id]["cmd_verb"] == "INST-ZIMS"){
        	var zim_id = job_status[job_id]["cmd_args"]["zim_id"];
        	consoleLog (zim_id);
          if (zimsScheduled.indexOf(zim_id) > -1){
            zimsScheduled.pop(zim_id);
            updateZimDiskSpaceUtil(zim_id, false)
            procZimGroups();
            //$( "input[name*='" + zim_id + "']" ).checked = false;
          }
        }
        this.checked = false;
      }
  });
  //consoleLog(cmdList);
  $.when.apply($, cmdList).then(getJobStat, procZimCatalog);
  alert ("Jobs marked for Cancellation.\n\nPlease click Refresh to see the results.");
  button_feedback("#CANCEL-JOBS", false);
});

$("#GET-INET-SPEED").click(function(){
  getInetSpeed();
});

$("#GET-INET-SPEED2").click(function(){
  getInetSpeed2();
});

// Other Objects
$("#gui_static_wan").change(function(){
  gui_static_wanVal();
});

function button_feedback(id, grey_out) {
	// true means grey out the button and disable, false means the opposite
  if (grey_out){
  	$(id).prop('disabled', true);
    $(id).css({opacity:".5"});
  }
  else {
  	$(id).css({opacity:"1"});
    $(id).prop('disabled', false);
  }
}

// Field Validations

function xsce_domainVal()
{
  //alert ("in xsce_domainVal");
  xsce_domain = $("#xsce_domain").val();
  consoleLog(xsce_domain);
  if (xsce_domain == ""){
    alert ("Domain Name can not be blank.");
    $("#xsce_domain").val(config_vars['xsce_domain'])
    setTimeout(function () {
      $("#xsce_domain").focus(); // hack for IE
    }, 100);
    return false;
  }
  // any regex match is invalid
  domainRegex = /^[\.\-]|[\.\-]$|[^\.a-zA-Z0-9-]/;
  if (domainRegex.test(xsce_domain)) {
    alert ("Domain Name can only have letters, numbers, dashes, and dots and may not have a dot or dash at beginning or end.");
    //$("#xsce_domain").val(config_vars['xsce_domain'])
    setTimeout(function () {
      $("#xsce_domain").focus(); // hack for IE
    }, 100);
    return false
  }

  return true;
}

function gui_static_wanVal()
{
  alert ("in gui_static_wanVal");
  // if static wan is checked make sure visit ip addr field
  if ($("#gui_static_wan").prop('checked')){
    setTimeout(function () {
      $("#gui_static_wan_ip_lsd").focus(); // hack for IE
    }, 100);
  }
}

function gui_static_wan_ip_lsdVal()
{
  //alert ("in gui_static_wan_ip_lsdVal");
  gui_static_wan_ip_lsd = $("#gui_static_wan_ip_lsd").val();
  consoleLog(gui_static_wan_ip_lsd);
  rc = false;
  if ($("#gui_static_wan").prop('checked')){
    if (gui_static_wan_ip_lsd == ""){
      alert ("Static IP Address can not be blank if use a static WAN IP Address is checked.");
    }
    else if (isNaN(gui_static_wan_ip_lsd)){
      alert ("Static IP Address must be a number.");
    }
    else if (parseInt(gui_static_wan_ip_lsd) < 2 || parseInt(gui_static_wan_ip_lsd) > 250){
      alert ("Static IP Address must be greater than 2 and less than 250.");
    }
    else
      rc = true;
    }
    if (rc == false){
      setTimeout(function () {
        $("#gui_static_wan_ip_lsd").focus(); // hack for IE
      }, 100);
      return false;
    }
    else
      return true;
}

//var testCmdHandler = function (data, textStatus, jqXHR) is not necessary
var testCmdHandler = function (data)
//function testCmdHandler (data)
{
  //alert ("in Cmdhandler");
  consoleLog(data);
  return true;
};

function listCmdHandler (data)
{
  //alert ("in listCmdHandler");
  consoleLog(data);
  //consoleLog(jqXHR);
  return true;
}

function genericCmdHandler (data)
{
  //alert ("in genericCmdHandler");
  consoleLog(data);
  //consoleLog(jqXHR);
  return true;
}

function getAnsibleFacts (data)
{
  //alert ("in getAnsibleFacts");
  consoleLog(data);
  ansibleFacts = data;
  var jstr = JSON.stringify(ansibleFacts, undefined, 2);
  var html = jstr.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;");
  $( "#ansibleFacts" ).html(html);
  //consoleLog(jqXHR);
  return true;
}

function getAnsibleTags (data)
{
  //alert ("in getAnsibleTags");
  consoleLog(data);
  ansibleTagsStr = data['ansible_tags'];
  ansibleTagsArr = ansibleTagsStr.split(',');
  var html = '<table width="80%"><tr>';
  j = 0;
  for (var i in ansibleTagsArr){
    html += '<td width="20%"><label><input type="checkbox" name="' + ansibleTagsArr[i] + '">' + ansibleTagsArr[i] + '</label></td>';
    if (j++ == 4){
      html += '</tr><tr>';
      j = 0;
    }
  }
  html += "</tr></table>";
  //consoleLog(html);
  //jstr = JSON.stringify(ansibleFacts, undefined, 2);
  //html = jstr.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;");
  $( "#ansibleTags" ).html(html);
  //consoleLog(jqXHR);
  return true;
}

function getInstallVars (data)
{
  //alert ("in getInstallVars");
  consoleLog(data);
  effective_vars = data;
  //consoleLog(jqXHR);
  return true;
}
function getConfigVars (data)
{
  //alert ("in getConfigVars");
  consoleLog(data);
  config_vars = data;
  return true;
}

function assignConfigVars (data)
{
  // If config_vars has a value use it
  // Otherwise if effective_vars has a value use it
  $('#Configure input').each( function(){
    if (config_vars.hasOwnProperty(this.name)){
      prop_val = config_vars[this.name];
      //consoleLog(this.name + "using config_vars");
    }
    else if (effective_vars.hasOwnProperty(this.name)){
      prop_val = effective_vars[this.name];
      config_vars[this.name] = effective_vars[this.name];
      //consoleLog(this.name + "using effective_vars");
    }
    else{
      if (this.type == "checkbox")
      prop_val = false;
      if (this.type == "text")
      prop_val = "";
      if (this.type == "radio")
      prop_val = "";
    }
    if (this.type == "checkbox")
    $(this).prop('checked', config_vars[this.name]);
    if (this.type == "text")
    this.value = config_vars[this.name];
    if (this.type == "radio"){
      // this will get called once for each button, but should only check one of the set
      setRadioButton(this.name, config_vars[this.name]);
    }
    //console.log($(this).val());
    //consoleLog(this.name);
  });
  //config_vars = data;
  //consoleLog(jqXHR);
  //initConfigVars()
  return true;
}

function setRadioButton(name, value){
  // id must follow the convention name-value
  field_id = "#" + name + "-" + value;
  //consoleLog(field_id);
  $(field_id).prop('checked', true);
}

function initConfigVars()
{
  assignConfigVars();
  var html = "Gateway: ";
  if(typeof ansibleFacts.ansible_default_ipv4.address === 'undefined'){
    html += "Not Found<BR>";
    $("#gui_static_wan").prop('checked', false);
    wan_ip_msd = "";
    gui_static_wan_ip_lsd = "";
  }
  else {
    html += "Found<BR>";
    html += "WAN: " + ansibleFacts.ansible_default_ipv4.address + " on " + ansibleFacts.ansible_default_ipv4.alias + "<BR>";
    wan_ip = ansibleFacts.ansible_default_ipv4.address.split(".");
    //consoleLog(wan_ip);
    wan_ip_msd = wan_ip[0] + "." + wan_ip[1] + "." + wan_ip[2] + ".";
    $("#gui_static_wan_ip_lsd").val(wan_ip[3]);
    $("#gui_wan_ip_msd").val(wan_ip_msd);
  }
  //consoleLog(config_vars);
  // html += "LAN:
  html += "Network Mode: " + xsce_ini.network.xsce_network_mode + "<BR>";
  $("#discoveredNetwork").html(html);
  if (typeof config_vars.gui_desired_network_role === "undefined")
  setRadioButton("gui_desired_network_role", xsce_ini.network.xsce_network_mode)
}

function setConfigVars ()
{
  cmd_args = {}
  //alert ("in setConfigVars");
  $('#Configure input').each( function(){
    if (this.type == "checkbox") {
      if (this.checked)
      config_vars[this.name] = true; // must be true not True
      else
        config_vars[this.name] = false;
      }
      if (this.type == "text")
      config_vars[this.name] = $(this).val();
      if (this.type == "radio"){
        fieldName = this.name;
        fieldName = "input[name=" + this.name + "]:checked"
        //consoleLog(fieldName);
        config_vars[this.name] = $(fieldName).val();
      }
    });
    cmd_args['config_vars'] = config_vars;
    cmd = "SET-CONF " + JSON.stringify(cmd_args);
    sendCmdSrvCmd(cmd, genericCmdHandler);
    alert ("Saving Configuration.");
    return true;
  }

  function getXsceIni (data)
  {
    //alert ("in getXsceIni");
    consoleLog(data);
    xsce_ini = data;
    jstr = JSON.stringify(xsce_ini, undefined, 2);
    var html = jstr.replace(/\n/g, "<br>").replace(/[ ]/g, "&nbsp;");
    $( "#xsceIni" ).html(html);
    //consoleLog(jqXHR);
    return true;
  }
  function getWhitelist (data)
  {
    //alert ("in getWhitelist");
    consoleLog(data);
    whlist_array = data['xsce_whitelist'];
    whlist_str = whlist_array[0];
    for (var i = 1; i < whlist_array.length; i++) {
      whlist_str += '\n' + whlist_array[i];
    }
    //$('#xsce_whitelist').val(data['xsce_whitelist']);
    $('#xsce_whitelist').val(whlist_str);
    return true;
  }

  function setWhitelist ()
  {
    //alert ("in setWhitelist");
    whlist_ret = {}
    whlist_array = $('#xsce_whitelist').val().split('\n');
    whlist_ret['xsce_whitelist'] = whlist_array;
    cmd = "SET-WHLIST " + JSON.stringify(whlist_ret);
    consoleLog(cmd);
    sendCmdSrvCmd(cmd, genericCmdHandler);
    alert ("Saving Permitted URLs List.");
    return true;
  }

  function runAnsible (tags)
  {
    command = formCommand("RUN-ANSIBLE", "tags", tags);
    //alert ("in runAnsible");
    consoleLog(command);
    sendCmdSrvCmd(command, genericCmdHandler);
    alert ("Scheduling Ansible Run.");
    return true;
  }

  // Install Content functions

  function instZim(zim_id)
  {
    zimsScheduled.push(zim_id);
    command = "INST-ZIMS"
    cmd_args = {}
    cmd_args['zim_id'] = zim_id;
    cmd = command + " " + JSON.stringify(cmd_args);
    sendCmdSrvCmd(cmd, genericCmdHandler, "", instZimError, cmd_args);
    return true;
  }

  function instZimError(data, cmd_args)
  {
    consoleLog(cmd_args);
    //cmdargs = JSON.parse(command);
    //consoleLog(cmdargs);
    consoleLog(cmd_args["zim_id"]);
    zimsScheduled.pop(cmd_args["zim_id"]);
    procZimGroups();
    return true;
  }

  function restartKiwix() // Restart Kiwix Server
  {
    command = "RESTART-KIWIX";
    sendCmdSrvCmd(command, genericCmdHandler);
    return true;
  }

  function getKiwixCatalog() // Downloads kiwix catalog from kiwix
  {
    command = "GET-KIWIX-CAT";
    sendCmdSrvCmd(command, procKiwixCatalog, "KIWIX-LIB-REFRESH");
    return true;
  }

  function getZimStat(){
    command = "GET-ZIM-STAT";
    sendCmdSrvCmd(command, procZimStat);
    return true;
  }

  function procKiwixCatalog() {
    readKiwixCatalog();
    procZimCatalog();
    alert ("Kiwix Catalog has been downloaded.");
  }

  function procZimStatInit(data) {
    installedZimCat = data;
  }

  function procZimStat(data) {
    installedZimCat = data;
    procZimCatalog();
  }

  function procZimLangs() {
    //consoleLog (zimLangs);
    var html = '';
    var topHtml = '';
    var bottomHtml = '';
    for (var i in langNames){
      html = '<span class="lang-codes"><label><input type="checkbox" name="' + langNames[i].code + '"';
      if (selectedLangs.indexOf(langNames[i].code) != -1)
      html += ' checked';
      html += '>&nbsp;&nbsp;<span>' + langNames[i].locname + '</span><span> (' + langNames[i].engname + ') [' + langNames[i].code + ']</span></label></span>';

      if (topNames.indexOf(langNames[i].code) >= 0 || selectedLangs.indexOf(langNames[i].code) != -1) {
        topHtml += html;
      }
      else {
        bottomHtml += html;
      }
    }
    $( "#ZimLanguages" ).html(topHtml);
    $( "#ZimLanguages2" ).html(bottomHtml);
  }

function procZimGroups() {
  // get list of selected langcodes
  selectedLangs = [];
  $('#selectLangCodes input').each( function(){
    if (this.checked) {
      selectedLangs.push(this.name);
    }
  });
  var html = "<br>";
  $.each(selectedLangs, function(index, lang) {
    //consoleLog(index);
    if (lang in zimGroups){
      //consoleLog (lang);
      html += "<h2>" + langCodes[lang]['locname'] + ' (' + langCodes[lang]['engname'] + ")</h2>";
      $.each(zimGroups[lang], function(key, zimList) {
        html += "<h3>" + key + "</h3>";
        $.each(zimList, function(key, zimId) {
          var zim = zimCatalog[zimId];
          var colorClass = "";
          var colorClass2 = "";
          if (zimsInstalled.indexOf(zimId) >= 0){
            colorClass = "installed";
            colorClass2 = 'class="installed"';
          }
          if (zimsScheduled.indexOf(zimId) >= 0){
            colorClass = "scheduled";
            colorClass2 = 'class="scheduled"';
          }
          html += '<label ';
          html += '><input type="checkbox" name="' + zimId + '"';
          //html += '><img src="images/' + zimId + '.png' + '"><input type="checkbox" name="' + zimId + '"';
          if ((zimsInstalled.indexOf(zimId) >= 0) || (zimsScheduled.indexOf(zimId) >= 0))
          html += 'disabled="disabled" checked="checked"';
          html += 'onChange="updateZimDiskSpace(this)"></label>'; // end input
          zimDesc = zim.title + ' (' + zim.description + ') [' + zim.perma_ref + ']';
          html += '<span class="zim-desc ' + colorClass + '" >&nbsp;&nbsp;' + zimDesc + '</span>';
          html += '<span ' + colorClass2 + 'style="display:inline-block; width:120px;"> Date: ' + zim.date + '</span>';
          html += '<span ' + colorClass2 +'> Size: ' + readableSize(zim.size);
          if (zimsInstalled.indexOf(zimId) >= 0)
          html += ' - INSTALLED';
          if (zimsScheduled.indexOf(zimId) >= 0)
          html += ' - WORKING ON IT';
          html += '</span><BR>';
        });
      });
    }
  });
  //consoleLog (html);
  $( "#ZimDownload" ).html(html);
}

function getLangCodes() {
  //alert ("in sendCmdSrvCmd(");
  //consoleLog ('ran sendCmdSrvCmd');
  //if (asyncFlag === undefined) asyncFlag = false;

  resp = $.ajax({
    type: 'GET',
    url: consoleJsonDir + 'lang_codes.json',
    dataType: 'json'
  })
  .done(function( data ) {
    langCodes = data;
    consoleLog(langCodes);
  })
  .fail(jsonErrhandler);

  return resp;
}

function readKiwixCatalog() { // Reads kiwix catalog from file system as json
  //alert ("in sendCmdSrvCmd(");
  //consoleLog ('ran sendCmdSrvCmd');
  //if (asyncFlag === undefined) asyncFlag = false;

  resp = $.ajax({
    type: 'GET',
    url: consoleJsonDir + 'kiwix_catalog.json',
    dataType: 'json'
  })
  .done(function( data ) {
    kiwixCatalog = data;
    consoleLog(kiwixCatalog);
  })
  .fail(jsonErrhandler);

  return resp;
}

function procZimCatalog() {
  // Uses installedZimCat, kiwixCatalog, langCodes, and langGroups
  // Calculates zimCatalog, zimGroups, langNames, zimsInstalled, zimsScheduled

  consoleLog('in procZimCatalog');

  zimCatalog = {};
  zimGroups = {};
  zimLangs = [];

  // Add to zimCatalog

  procOneCatalog(installedZimCat['INSTALLED']);
  procOneCatalog(installedZimCat['WIP']);
  procOneCatalog(kiwixCatalog);

  // Create working arrays of installed and wip
  zimsInstalled = [];
  zimsScheduled = [];
  for (var id in installedZimCat['INSTALLED']){
    zimsInstalled.push(id);
    lang = installedZimCat['INSTALLED'][id]['language'];
    if (selectedLangs.indexOf(lang) == -1) // automatically select any language for which zim is installed
    selectedLangs.push (lang);
  }
  for (var id in installedZimCat['WIP']){
    zimsScheduled.push(id);
    lang = installedZimCat['WIP'][id]['language'];
    if (selectedLangs.indexOf(lang) == -1) // automatically select any language for which zim is being installed
    selectedLangs.push (lang);
  }

  if (selectedLangs.length == 0)
  selectedLangs.push (defaultLang); // default

  sortZimLangs(); // Create langNames from zimLangs and sort
  procZimLangs(); // Create language menu
  procZimGroups(); // Create zim list for selected languages

  return true;
}

function procOneCatalog(catalog){
  if (Object.keys(catalog).length > 0){
    for (var id in catalog) {
      var lang = catalog[id].language;
      if (lang in langGroups)
      lang = langGroups[lang]; // group synomyms like en/eng
      var cat = catalog[id].creator;

      if (!(lang in zimGroups)){
        var cats = {};
        cats[cat] = [];
        zimGroups[lang] = cats;
      }

      if (!(cat in zimGroups[lang]))
      zimGroups[lang][cat] = [];

      if (zimGroups[lang][cat].indexOf(id) == -1)
      zimGroups[lang][cat].push (id);

      zimCatalog[id] = catalog[id]; // add to working catalog
      if (zimLangs.indexOf(lang) == -1)
      zimLangs.push(lang);
    }
  }
}

function readableSize(kbytes) {
  if (kbytes == 0)
  return "0";
  var bytes = 1024 * kbytes;
  var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'];
  var e = Math.floor(Math.log(bytes) / Math.log(1024));
  return (bytes / Math.pow(1024, e)).toFixed(2) + " " + s[e];
}

function sortZimLangs(){
  langNames = [];
  for (var i in zimLangs){
    if (langCodes[zimLangs[i]] === undefined){ // for now ignore languages we don't know
      consoleLog('Language code ' + zimLangs[i] + ' not in langCodes.');
      continue;
    }
    attr = {};
    attr.locname = langCodes[zimLangs[i]]['locname'];
    attr.code = zimLangs[i];
    attr.engname = langCodes[zimLangs[i]]['engname'];
    langNames.push(attr);
  }
  langNames = langNames.sort(function(a,b){
    if (a.locname < b.locname) return -1;
    else return 1;
    });
}

// Util functions

function getJobStat()
{
  command = "GET-JOB-STAT"
  sendCmdSrvCmd(command, procJobStat);
  return true;
}

function procJobStat(data)
{
  job_status = {};
  var html = "";
  var html_break = '<br>';

  data.forEach(function(entry) {
    //console.log(entry);
    html += "<tr>";
    job_info = {};

    job_info['job_no'] = entry[0];
    html += "<td>" + entry[0] + "<BR>"; // job number
    // html +=  '<input type="checkbox" name="' gw_squid_whitelist + '" id="' xo-gw_squid_whitelist +'">';
    jobId = "job_stat_id-" + entry[0];
    html +=  '<input type="checkbox" id="' + jobId + '">';
    html += "</td>";
    job_info['command'] = entry[1];
    html += '<td style="overflow: hidden; text-overflow: ellipsis">' + entry[1] + "</td>";

    result = entry[2].replace(/(?:\r\n|\r|\n)/g, html_break); // change newline to BR
    // result = result.replace(html_break+html_break, html_break); // remove blank lines, but doesn't work
    idx = result.indexOf(html_break);
    if (idx =0) result = result.substring(html_break.length); // strip off first newline
    idx = result.lastIndexOf(html_break);
    if (idx >=0) result = result.substring(0,idx); // strip off last newline
    job_info['result'] = result;

    idx = result.lastIndexOf(html_break);  // find 2nd to last newline
    result_end = "";
    if (idx >=0) result_end = result.substring(0,idx + html_break.length);
    html += '<td> <div class = "statusJobResult">' + result + "</div></td>";

    job_info['status'] = entry[3];
    html += "<td>" + entry[3] + "</td>";
    job_info['status_date'] = entry[4];
    html += "<td>" + entry[4] + "</td>";

    html += "</tr>";

    // there should be one or two parts
    var cmd_parse = entry[5].split(" ");
    job_info['cmd_verb'] = cmd_parse[0];
    if(cmd_parse.length == 0 || typeof cmd_parse[1] === 'undefined')
      job_info['cmd_args'] = ""
    else
      job_info['cmd_args'] = JSON.parse(cmd_parse[1]);

    consoleLog(job_info);
    job_status[job_info['job_no']] = job_info;

  });
  $( "#jobStatTable tbody" ).html(html);
  $( "#jobStatTable div.statusJobResult" ).each(function( index ) {
    $(this).scrollTop(this.scrollHeight);
  });
  today = new Date();
  $( "#statusJobsRefreshTime" ).html("Last Refreshed: <b>" + today + "</b>");
}

function cancelJob(job_id)
{
  command = "CANCEL-JOB"
  cmd_args = {}
  cmd_args['job_id'] = job_id;
  cmd = command + " " + JSON.stringify(cmd_args);
  $.when(sendCmdSrvCmd(cmd, genericCmdHandler)).then(getJobStat);
  return true;
}

function cancelJobFunc(job_id)
{
  command = "CANCEL-JOB"
  cmd_args = {}
  cmd_args['job_id'] = job_id;
  cmd = command + " " + JSON.stringify(cmd_args);
  return $.Deferred( function () {
  	var self = this;
  	sendCmdSrvCmd(cmd, genericCmdHandler);
  	});
}

function getSysMem()
{
  command = "GET-MEM-INFO"
  sendCmdSrvCmd(command, procSysMem);
  return true;
}

function procSysMem(data)
{
  //alert ("in procSysMem");
  consoleLog(data);
  sysMemory = data['system_memory'];
  var html = "";
  for (var i in sysMemory)
  html += sysMemory[i] + "<BR>"

  $( "#sysMemory" ).html(html);
  //consoleLog(jqXHR);
  return true;
}

function refreshDiskSpace(){
  $.when(sendCmdSrvCmd("GET-STORAGE-INFO", procSysStorageDat),sendCmdSrvCmd("GET-ZIM-STAT", procZimStatInit)).then(procDiskSpace);
}

function procDiskSpace(){
  //procZimGroups(); - don't call because resets check boxes
  procSysStorage();
  sumCheckedZimDiskSpace()
  // setZimDiskSpace(); called by previous
}

function getSysStorage()
{
  command = "GET-STORAGE-INFO"
  sendCmdSrvCmd(command, procSysStorageAll);
  return true;
}

function procSysStorageAll(data)
{
  //alert ("in procSysStorageDat");
  consoleLog(data);
  sysStorage.raw = data;
  procSysStorage();
  setZimDiskSpace();
}

function procSysStorageDat(data)
{
  //alert ("in procSysStorageDat");
  consoleLog(data);
  sysStorage.raw = data;
}

function procSysStorage()
{
  //alert ("in procSysStorage");
  sysStorage.root = {};
  sysStorage.library = {};
  sysStorage.library.partition = false; // no separate library partition

  var html = "";
  for (var i in sysStorage.raw) {
    dev = sysStorage.raw[i];
    html += "<b>" + dev.device + "</b>";
    html += " " + dev.desc;
    html += " " + dev.type;
    html += " " + dev.size;
    html += ":<BR><BR>";

    for (j in sysStorage.raw[i].blocks){
      block = dev.blocks[j];
      html += block.part_dev;
      if (block.part_dev == 'unallocated')
      html += " " + block.size;
      else {
        html += " " + block.type;
        html += " " + block.size;
        if (block.part_prop.TYPE != "\"swap\""){
          html += " (" + block.part_prop.avail_in_megs + "M avail)";
          html += " " + block.part_prop.mount_point;
          if (block.part_prop.mount_point == "/"){
            sysStorage.root.part_dev = block.part_dev;
            sysStorage.root.avail_in_megs = block.part_prop.avail_in_megs;
          }
          if (block.part_prop.mount_point == "/library"){
            sysStorage.library.part_dev = block.part_dev;
            sysStorage.library.avail_in_megs = block.part_prop.avail_in_megs;
            sysStorage.library.partition = true;
          }
        }
      }
      html += "<BR>";
    }
    html += "<BR>";
  }
  $( "#sysStorage" ).html(html);

  //consoleLog(jqXHR);
  return true;
}

function setZimDiskSpace(){
  var html = "Library Space Available : <b>";
  var avail_in_megs;
  var zims_selected_size;

  if (sysStorage.library.partition == true)
  avail_in_megs = sysStorage.library.avail_in_megs;
  else
    avail_in_megs = sysStorage.root.avail_in_megs;

    html += readableSize(avail_in_megs * 1024) + "</b><BR>";

    html += "Total Space Selected: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>";
    html += readableSize(sysStorage.zims_selected_size) + "</b>"
    $( "#instZimsDiskSpace" ).html(html);
}

function updateZimDiskSpace(cb){
  var zim_id = cb.name
  updateZimDiskSpaceUtil(zim_id, cb.checked);
}

function updateZimDiskSpaceUtil(zim_id, checked){
  var zim = zimCatalog[zim_id]
  var size =  parseInt(zim.size);

  var zimIdx = selectedZims.indexOf(zim_id);

  if (checked){
    if (zimsInstalled.indexOf(zim_id) == -1){ // only update if not already installed zims
      sysStorage.zims_selected_size += size;
      selectedZims.push(zim_id);
    }
  }
  else {
    if (zimIdx != -1){
      sysStorage.zims_selected_size -= size;
      selectedZims.splice(zimIdx, 1);
    }
  }

  setZimDiskSpace();

}

function sumCheckedZimDiskSpace(){
  var zim_id = '';
  var zim = {};
  var size = 0;

  sysStorage.zims_selected_size = 0;

  for (var i in selectedZims){
    zim_id = selectedZims[i]
    zim = zimCatalog[zim_id];
    var size =  parseInt(zim.size);

    sysStorage.zims_selected_size += size;

    setZimDiskSpace();
  }
}

function getInetSpeed(){
  command = "GET-INET-SPEED";
  sendCmdSrvCmd(command, procInetSpeed, "GET-INET-SPEED");
  $( "#intSpeed1" ).html("Working ...");
  //$('#myModal').modal('show');
  return true;
}

function procInetSpeed(data){
  //alert ("in procInetSpeed");
  consoleLog(data);
  intSpeed = data["internet_speed"];
  var html = "";
  for (var i in intSpeed)
  html += intSpeed[i] + "<BR>"

  $( "#intSpeed1" ).html(html);
  return true;
}

function getInetSpeed2(){
  command = "GET-INET-SPEED2"
  sendCmdSrvCmd(command, procInetSpeed2, "GET-INET-SPEED2");
  $( "#intSpeed2" ).html("Working ...");
  return true;
}

function procInetSpeed2(data){
  //alert ("in procInetSpeed2");
  consoleLog(data);
  intSpeed = data["internet_speed"];
  var html = "";
  for (var i in intSpeed)
  html += intSpeed[i] + "<BR>"

  $( "#intSpeed2" ).html(html);
  //consoleLog(jqXHR);
}


function rebootServer()
{
  command = "REBOOT"
  sendCmdSrvCmd(command, genericCmdHandler);
  alert ("Reboot Initiated");
  return true;
}

function poweroffServer()
{
  command = "POWEROFF"
  sendCmdSrvCmd(command, genericCmdHandler);
  alert ("Shutdown Initiated");
  return true;
}

function getHelp(arg)
{
  $.get( "help/" + arg, function( data ) {
    rst = data;
    convert = new Markdown.getSanitizingConverter().makeHtml;
    html = convert(rst);
    $( "#helpItem" ).html( html );
  });
  return true;
}

function formCommand(cmd_verb, args_name, args_obj)
{
  cmd_args = {}
  cmd_args[args_name] = args_obj;
  command = cmd_verb + " " + JSON.stringify(cmd_args);
  consoleLog(command);

  return command;
}

// monitor for awhile and use version if no problems present

function sendCmdSrvCmd(command, callback, buttonId, errCallback, cmdArgs) {
  // takes following arguments:
  //   command - Command to send to cmdsrv
  //   callback - Function to call on success
  //   buttonId - Optional ID of button to disable and re-enable
  //   errCallback - Optional function to call if return from cmdsrv has error object; not the same as an error in ajax
  //   cmdArgs - Optional arguments to original command for use by errCallback
  //   TODO  - add assignmentVar to can assign variable before running callback
  //alert ("in sendCmdSrvCmd(");
  //consoleLog ('buttonid = ' + buttonId);;
  if (buttonId === undefined)
  buttonId = "";
  else
    button_feedback('#' + buttonId, true);

    resp = $.ajax({
      type: 'POST',
      url: 'cmd-service.php',
      data: {
        command: command
      },
      dataType: 'json',
      buttonId: buttonId
    })
    //.done(callback)
    .done(function(data) {
    	var dataResp = data;
    	if ("Error" in dataResp){
    	  consoleLog(dataResp["Error"]);
    	  globalAjaxErrorFlag = true;
    	  alert("Error: " + dataResp["Error"]);
    	  if (typeof errCallback != 'undefined'){
    	    consoleLog(errCallback);
    	    errCallback(data, cmdArgs);
    	  }
    	}
    	else
    	  callback(data);
    })
    .fail(jsonErrhandler)
    .always(function() {
      button_feedback('#' + this.buttonId, false);
    });

    return resp;
}

function jsonErrhandler (jqXHR, textStatus, errorThrown)
{
  alert ("in Errhandler: " + textStatus + ", " + errorThrown);
  //consoleLog("In Error Handler logging jqXHR");
  consoleLog(textStatus);
  consoleLog(errorThrown);
  consoleLog(jqXHR);
  globalAjaxErrorFlag = true;
  consoleLog(globalAjaxErrorFlag);
  return false;
}
function consoleLog (msg)
{
  console.log(msg); // for IE there can be no console messages unless in tools mode
}

function init ()
{
  $('#initDataModal').modal('show');
  globalAjaxErrorFlag = false;

  $.when(
    sendCmdSrvCmd("GET-ANS-TAGS", getAnsibleTags),
    sendCmdSrvCmd("GET-WHLIST", getWhitelist),
    $.when(sendCmdSrvCmd("GET-VARS", getInstallVars), sendCmdSrvCmd("GET-ANS", getAnsibleFacts),sendCmdSrvCmd("GET-CONF", getConfigVars),sendCmdSrvCmd("GET-XSCE-INI", getXsceIni)).done(initConfigVars),
    $.when(getLangCodes(),readKiwixCatalog(),sendCmdSrvCmd("GET-ZIM-STAT", procZimStatInit)).done(procZimCatalog),
    sendCmdSrvCmd("GET-STORAGE-INFO", procSysStorageAll),
    waitDeferred(3000))
    .done(initDone)
    .fail(function () {consoleLog("failed");})
}

function initDone ()
{
	if (globalAjaxErrorFlag == false){
	  consoleLog("Init Finished Successfully");
	  $('#initDataModal').modal('hide');
  } else {
    consoleLog("Init Failed");
    $('#initDataModalResult').html("<b>There was an error on the Server.</b>");
  }
}

function waitDeferred(msec) {
    var deferredObject = $.Deferred();

    setTimeout(function() { deferredObject.resolve();  }, msec);

    return deferredObject.promise();
}