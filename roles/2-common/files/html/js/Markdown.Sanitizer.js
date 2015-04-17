



<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
 <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" >
 
 <meta name="ROBOTS" content="NOARCHIVE">
 
 <link rel="icon" type="image/vnd.microsoft.icon" href="https://ssl.gstatic.com/codesite/ph/images/phosting.ico">
 
 
 <script type="text/javascript">
 
 
 
 
 var codesite_token = "ABZ6GAcA43V37sPxuGzfUMfsP_ZO-yYC4g:1429209827111";
 
 
 var CS_env = {"projectName": "pagedown", "loggedInUserEmail": "timm.newyyz@gmail.com", "profileUrl": "/u/116895727412923837559/", "assetVersionPath": "https://ssl.gstatic.com/codesite/ph/1191371308984722110", "token": "ABZ6GAcA43V37sPxuGzfUMfsP_ZO-yYC4g:1429209827111", "projectHomeUrl": "/p/pagedown", "relativeBaseUrl": "", "assetHostPath": "https://ssl.gstatic.com/codesite/ph", "domainName": null};
 var _gaq = _gaq || [];
 _gaq.push(
 ['siteTracker._setAccount', 'UA-18071-1'],
 ['siteTracker._trackPageview']);
 
 (function() {
 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
 (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
 })();
 
 </script>
 
 
 <title>Markdown.Sanitizer.js - 
 pagedown -
 
 
 A JavaScript Markdown converter and editor - Google Project Hosting
 </title>
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/1191371308984722110/css/core.css">
 
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/1191371308984722110/css/ph_detail.css" >
 
 
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/1191371308984722110/css/d_sb.css" >
 
 
 
<!--[if IE]>
 <link type="text/css" rel="stylesheet" href="https://ssl.gstatic.com/codesite/ph/1191371308984722110/css/d_ie.css" >
<![endif]-->
 <style type="text/css">
 .menuIcon.off { background: no-repeat url(https://ssl.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -42px }
 .menuIcon.on { background: no-repeat url(https://ssl.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -28px }
 .menuIcon.down { background: no-repeat url(https://ssl.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 0; }
 
 
 
  tr.inline_comment {
 background: #fff;
 vertical-align: top;
 }
 div.draft, div.published {
 padding: .3em;
 border: 1px solid #999; 
 margin-bottom: .1em;
 font-family: arial, sans-serif;
 max-width: 60em;
 }
 div.draft {
 background: #ffa;
 } 
 div.published {
 background: #e5ecf9;
 }
 div.published .body, div.draft .body {
 padding: .5em .1em .1em .1em;
 max-width: 60em;
 white-space: pre-wrap;
 white-space: -moz-pre-wrap;
 white-space: -pre-wrap;
 white-space: -o-pre-wrap;
 word-wrap: break-word;
 font-size: 1em;
 }
 div.draft .actions {
 margin-left: 1em;
 font-size: 90%;
 }
 div.draft form {
 padding: .5em .5em .5em 0;
 }
 div.draft textarea, div.published textarea {
 width: 95%;
 height: 10em;
 font-family: arial, sans-serif;
 margin-bottom: .5em;
 }

 
 .nocursor, .nocursor td, .cursor_hidden, .cursor_hidden td {
 background-color: white;
 height: 2px;
 }
 .cursor, .cursor td {
 background-color: darkblue;
 height: 2px;
 display: '';
 }
 
 
.list {
 border: 1px solid white;
 border-bottom: 0;
}

 
 </style>
</head>
<body class="t4">
<script type="text/javascript">
 window.___gcfg = {lang: 'en'};
 (function() 
 {var po = document.createElement("script");
 po.type = "text/javascript"; po.async = true;po.src = "https://apis.google.com/js/plusone.js";
 var s = document.getElementsByTagName("script")[0];
 s.parentNode.insertBefore(po, s);
 })();
</script>
<div class="headbg">

 <div id="gaia">
 

 <span>
 
 
 
 <a href="#" id="multilogin-dropdown" onclick="return false;"
 ><u><b>timm.newyyz@gmail.com</b></u> <small>&#9660;</small></a>
 
 
 | <a href="/u/116895727412923837559/" id="projects-dropdown" onclick="return false;"
 ><u>My favorites</u> <small>&#9660;</small></a>
 | <a href="/u/116895727412923837559/" onclick="_CS_click('/gb/ph/profile');"
 title="Profile, Updates, and Settings"
 ><u>Profile</u></a>
 | <a href="https://www.google.com/accounts/Logout?continue=https%3A%2F%2Fcode.google.com%2Fp%2Fpagedown%2Fsource%2Fbrowse%2FMarkdown.Sanitizer.js" 
 onclick="_CS_click('/gb/ph/signout');"
 ><u>Sign out</u></a>
 
 </span>

 </div>

 <div class="gbh" style="left: 0pt;"></div>
 <div class="gbh" style="right: 0pt;"></div>
 
 
 <div style="height: 1px"></div>
<!--[if lte IE 7]>
<div style="text-align:center;">
Your version of Internet Explorer is not supported. Try a browser that
contributes to open source, such as <a href="http://www.firefox.com">Firefox</a>,
<a href="http://www.google.com/chrome">Google Chrome</a>, or
<a href="http://code.google.com/chrome/chromeframe/">Google Chrome Frame</a>.
</div>
<![endif]-->

 <div style="font-weight:bold; color:#a03; padding:5px; margin-top:10px; text-align:center; background:#ffeac0;">
 Project Hosting is currently READ-ONLY for network maintenance.
 
 </div>



 <table style="padding:0px; margin: 0px 0px 10px 0px; width:100%" cellpadding="0" cellspacing="0"
 itemscope itemtype="http://schema.org/CreativeWork">
 <tr style="height: 58px;">
 
 
 
 <td id="plogo">
 <link itemprop="url" href="/p/pagedown">
 <a href="/p/pagedown/">
 
 <img src="https://ssl.gstatic.com/codesite/ph/images/defaultlogo.png" alt="Logo" itemprop="image">
 
 </a>
 </td>
 
 <td style="padding-left: 0.5em">
 
 <div id="pname">
 <a href="/p/pagedown/"><span itemprop="name">pagedown</span></a>
 </div>
 
 <div id="psum">
 <a id="project_summary_link"
 href="/p/pagedown/"><span itemprop="description">A JavaScript Markdown converter and editor</span></a>
 
 </div>
 
 
 </td>
 <td style="white-space:nowrap;text-align:right; vertical-align:bottom;">
 
 <form action="/hosting/search">
 <input size="30" name="q" value="" type="text">
 
 <input type="submit" name="projectsearch" value="Search projects" >
 </form>
 
 </tr>
 </table>

</div>

 
<div id="mt" class="gtb"> 
 <a href="/p/pagedown/" class="tab ">Project&nbsp;Home</a>
 
 
 
 
 
 
 <a href="/p/pagedown/w/list" class="tab ">Wiki</a>
 
 
 
 
 
 <a href="/p/pagedown/issues/list"
 class="tab ">Issues</a>
 
 
 
 
 
 <a href="/p/pagedown/source/checkout"
 class="tab active">Source</a>
 
 
 
 
 
 
 
 
 <a href="https://code.google.com/export-to-github/export?project=pagedown">
 <button>Export to GitHub</button>
 
 </a>
 
 
 
 <div class=gtbc></div>
</div>
<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0" class="st">
 <tr>
 
 
 
 
 
 
 <td class="subt">
 <div class="st2">
 <div class="isf">
 
 <form action="/p/pagedown/source/browse" style="display: inline">
 
 Repository:
 <select name="repo" id="repo" style="font-size: 92%" onchange="submit()">
 <option value="default">default</option><option value="wiki">wiki</option>
 </select>
 </form>
 
 


 <span class="inst1"><a href="/p/pagedown/source/checkout">Checkout</a></span> &nbsp;
 <span class="inst2"><a href="/p/pagedown/source/browse/">Browse</a></span> &nbsp;
 <span class="inst3"><a href="/p/pagedown/source/list">Changes</a></span> &nbsp;
 <span class="inst4"><a href="/p/pagedown/source/clones">Clones</a></span> &nbsp; 
 
 
 
 
 
 
 </form>
 <script type="text/javascript">
 
 function codesearchQuery(form) {
 var query = document.getElementById('q').value;
 if (query) { form.action += '%20' + query; }
 }
 </script>
 </div>
</div>

 </td>
 
 
 
 <td align="right" valign="top" class="bevel-right"></td>
 </tr>
</table>


<script type="text/javascript">
 var cancelBubble = false;
 function _go(url) { document.location = url; }
</script>
<div id="maincol"
 
>

 




<div class="expand">
<div id="colcontrol">
<style type="text/css">
 #file_flipper { white-space: nowrap; padding-right: 2em; }
 #file_flipper.hidden { display: none; }
 #file_flipper .pagelink { color: #0000CC; text-decoration: underline; }
 #file_flipper #visiblefiles { padding-left: 0.5em; padding-right: 0.5em; }
</style>
<table id="nav_and_rev" class="list"
 cellpadding="0" cellspacing="0" width="100%">
 <tr>
 
 <td nowrap="nowrap" class="src_crumbs src_nav" width="33%">
 <strong class="src_nav">Source path:&nbsp;</strong>
 <span id="crumb_root">
 
 <a href="/p/pagedown/source/browse/">hg</a>/&nbsp;</span>
 <span id="crumb_links" class="ifClosed">Markdown.Sanitizer.js</span>
 
 

 <span class="sourcelabel">Download
 <a href="//pagedown.googlecode.com/archive/2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b.zip" rel="nofollow">zip</a> | <a href="//pagedown.googlecode.com/archive/2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b.tar.gz" rel="nofollow">tar.gz</a>
 </span>


 </td>
 
 
 <td nowrap="nowrap" width="33%" align="right">
 <table cellpadding="0" cellspacing="0" style="font-size: 100%"><tr>
 
 
 <td class="flipper">
 <ul class="leftside">
 
 <li><a href="/p/pagedown/source/browse/Markdown.Sanitizer.js?r=016a78c093843e203de5364117d34d406a09e8c0" title="Previous">&lsaquo;016a78c09384</a></li>
 
 </ul>
 </td>
 
 <td class="flipper"><b>2a8c75ce3fb5</b></td>
 
 </tr></table>
 </td> 
 </tr>
</table>

<div class="fc">
 
 
 
<style type="text/css">
.undermouse span {
 background-image: url(https://ssl.gstatic.com/codesite/ph/images/comments.gif); }
</style>
<table class="opened" id="review_comment_area"
><tr>
<td id="nums">
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
<pre><table width="100%" id="nums_table_0"><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_1"

><td id="1"><a href="#1">1</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_2"

><td id="2"><a href="#2">2</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_3"

><td id="3"><a href="#3">3</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_4"

><td id="4"><a href="#4">4</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_5"

><td id="5"><a href="#5">5</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_6"

><td id="6"><a href="#6">6</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_7"

><td id="7"><a href="#7">7</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_8"

><td id="8"><a href="#8">8</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_9"

><td id="9"><a href="#9">9</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_10"

><td id="10"><a href="#10">10</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_11"

><td id="11"><a href="#11">11</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_12"

><td id="12"><a href="#12">12</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_13"

><td id="13"><a href="#13">13</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_14"

><td id="14"><a href="#14">14</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_15"

><td id="15"><a href="#15">15</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_16"

><td id="16"><a href="#16">16</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_17"

><td id="17"><a href="#17">17</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_18"

><td id="18"><a href="#18">18</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_19"

><td id="19"><a href="#19">19</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_20"

><td id="20"><a href="#20">20</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_21"

><td id="21"><a href="#21">21</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_22"

><td id="22"><a href="#22">22</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_23"

><td id="23"><a href="#23">23</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_24"

><td id="24"><a href="#24">24</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_25"

><td id="25"><a href="#25">25</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_26"

><td id="26"><a href="#26">26</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_27"

><td id="27"><a href="#27">27</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_28"

><td id="28"><a href="#28">28</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_29"

><td id="29"><a href="#29">29</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_30"

><td id="30"><a href="#30">30</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_31"

><td id="31"><a href="#31">31</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_32"

><td id="32"><a href="#32">32</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_33"

><td id="33"><a href="#33">33</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_34"

><td id="34"><a href="#34">34</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_35"

><td id="35"><a href="#35">35</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_36"

><td id="36"><a href="#36">36</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_37"

><td id="37"><a href="#37">37</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_38"

><td id="38"><a href="#38">38</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_39"

><td id="39"><a href="#39">39</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_40"

><td id="40"><a href="#40">40</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_41"

><td id="41"><a href="#41">41</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_42"

><td id="42"><a href="#42">42</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_43"

><td id="43"><a href="#43">43</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_44"

><td id="44"><a href="#44">44</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_45"

><td id="45"><a href="#45">45</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_46"

><td id="46"><a href="#46">46</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_47"

><td id="47"><a href="#47">47</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_48"

><td id="48"><a href="#48">48</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_49"

><td id="49"><a href="#49">49</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_50"

><td id="50"><a href="#50">50</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_51"

><td id="51"><a href="#51">51</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_52"

><td id="52"><a href="#52">52</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_53"

><td id="53"><a href="#53">53</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_54"

><td id="54"><a href="#54">54</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_55"

><td id="55"><a href="#55">55</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_56"

><td id="56"><a href="#56">56</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_57"

><td id="57"><a href="#57">57</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_58"

><td id="58"><a href="#58">58</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_59"

><td id="59"><a href="#59">59</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_60"

><td id="60"><a href="#60">60</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_61"

><td id="61"><a href="#61">61</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_62"

><td id="62"><a href="#62">62</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_63"

><td id="63"><a href="#63">63</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_64"

><td id="64"><a href="#64">64</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_65"

><td id="65"><a href="#65">65</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_66"

><td id="66"><a href="#66">66</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_67"

><td id="67"><a href="#67">67</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_68"

><td id="68"><a href="#68">68</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_69"

><td id="69"><a href="#69">69</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_70"

><td id="70"><a href="#70">70</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_71"

><td id="71"><a href="#71">71</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_72"

><td id="72"><a href="#72">72</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_73"

><td id="73"><a href="#73">73</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_74"

><td id="74"><a href="#74">74</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_75"

><td id="75"><a href="#75">75</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_76"

><td id="76"><a href="#76">76</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_77"

><td id="77"><a href="#77">77</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_78"

><td id="78"><a href="#78">78</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_79"

><td id="79"><a href="#79">79</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_80"

><td id="80"><a href="#80">80</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_81"

><td id="81"><a href="#81">81</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_82"

><td id="82"><a href="#82">82</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_83"

><td id="83"><a href="#83">83</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_84"

><td id="84"><a href="#84">84</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_85"

><td id="85"><a href="#85">85</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_86"

><td id="86"><a href="#86">86</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_87"

><td id="87"><a href="#87">87</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_88"

><td id="88"><a href="#88">88</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_89"

><td id="89"><a href="#89">89</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_90"

><td id="90"><a href="#90">90</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_91"

><td id="91"><a href="#91">91</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_92"

><td id="92"><a href="#92">92</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_93"

><td id="93"><a href="#93">93</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_94"

><td id="94"><a href="#94">94</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_95"

><td id="95"><a href="#95">95</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_96"

><td id="96"><a href="#96">96</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_97"

><td id="97"><a href="#97">97</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_98"

><td id="98"><a href="#98">98</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_99"

><td id="99"><a href="#99">99</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_100"

><td id="100"><a href="#100">100</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_101"

><td id="101"><a href="#101">101</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_102"

><td id="102"><a href="#102">102</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_103"

><td id="103"><a href="#103">103</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_104"

><td id="104"><a href="#104">104</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_105"

><td id="105"><a href="#105">105</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_106"

><td id="106"><a href="#106">106</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_107"

><td id="107"><a href="#107">107</a></td></tr
><tr id="gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_108"

><td id="108"><a href="#108">108</a></td></tr
></table></pre>
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
</td>
<td id="lines">
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
<pre class="prettyprint lang-js"><table id="src_table_0"><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_1

><td class="source">(function () {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_2

><td class="source">    var output, Converter;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_3

><td class="source">    if (typeof exports === &quot;object&quot; &amp;&amp; typeof require === &quot;function&quot;) { // we&#39;re in a CommonJS (e.g. Node.js) module<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_4

><td class="source">        output = exports;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_5

><td class="source">        Converter = require(&quot;./Markdown.Converter&quot;).Converter;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_6

><td class="source">    } else {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_7

><td class="source">        output = window.Markdown;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_8

><td class="source">        Converter = output.Converter;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_9

><td class="source">    }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_10

><td class="source">        <br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_11

><td class="source">    output.getSanitizingConverter = function () {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_12

><td class="source">        var converter = new Converter();<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_13

><td class="source">        converter.hooks.chain(&quot;postConversion&quot;, sanitizeHtml);<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_14

><td class="source">        converter.hooks.chain(&quot;postConversion&quot;, balanceTags);<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_15

><td class="source">        return converter;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_16

><td class="source">    }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_17

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_18

><td class="source">    function sanitizeHtml(html) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_19

><td class="source">        return html.replace(/&lt;[^&gt;]*&gt;?/gi, sanitizeTag);<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_20

><td class="source">    }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_21

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_22

><td class="source">    // (tags that can be opened/closed) | (tags that stand alone)<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_23

><td class="source">    var basic_tag_whitelist = /^(&lt;\/?(b|blockquote|code|del|dd|dl|dt|em|h1|h2|h3|i|kbd|li|ol(?: start=&quot;\d+&quot;)?|p|pre|s|sup|sub|strong|strike|ul)&gt;|&lt;(br|hr)\s?\/?&gt;)$/i;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_24

><td class="source">    // &lt;a href=&quot;url...&quot; optional title&gt;|&lt;/a&gt;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_25

><td class="source">    var a_white = /^(&lt;a\shref=&quot;((https?|ftp):\/\/|\/)[-A-Za-z0-9+&amp;@#\/%?=~_|!:,.;\(\)*[\]$]+&quot;(\stitle=&quot;[^&quot;&lt;&gt;]+&quot;)?\s?&gt;|&lt;\/a&gt;)$/i;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_26

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_27

><td class="source">    // &lt;img src=&quot;url...&quot; optional width  optional height  optional alt  optional title<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_28

><td class="source">    var img_white = /^(&lt;img\ssrc=&quot;(https?:\/\/|\/)[-A-Za-z0-9+&amp;@#\/%?=~_|!:,.;\(\)*[\]$]+&quot;(\swidth=&quot;\d{1,3}&quot;)?(\sheight=&quot;\d{1,3}&quot;)?(\salt=&quot;[^&quot;&lt;&gt;]*&quot;)?(\stitle=&quot;[^&quot;&lt;&gt;]*&quot;)?\s?\/?&gt;)$/i;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_29

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_30

><td class="source">    function sanitizeTag(tag) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_31

><td class="source">        if (tag.match(basic_tag_whitelist) || tag.match(a_white) || tag.match(img_white))<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_32

><td class="source">            return tag;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_33

><td class="source">        else<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_34

><td class="source">            return &quot;&quot;;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_35

><td class="source">    }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_36

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_37

><td class="source">    /// &lt;summary&gt;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_38

><td class="source">    /// attempt to balance HTML tags in the html string<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_39

><td class="source">    /// by removing any unmatched opening or closing tags<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_40

><td class="source">    /// IMPORTANT: we *assume* HTML has *already* been <br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_41

><td class="source">    /// sanitized and is safe/sane before balancing!<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_42

><td class="source">    /// <br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_43

><td class="source">    /// adapted from CODESNIPPET: A8591DBA-D1D3-11DE-947C-BA5556D89593<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_44

><td class="source">    /// &lt;/summary&gt;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_45

><td class="source">    function balanceTags(html) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_46

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_47

><td class="source">        if (html == &quot;&quot;)<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_48

><td class="source">            return &quot;&quot;;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_49

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_50

><td class="source">        var re = /&lt;\/?\w+[^&gt;]*(\s|$|&gt;)/g;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_51

><td class="source">        // convert everything to lower case; this makes<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_52

><td class="source">        // our case insensitive comparisons easier<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_53

><td class="source">        var tags = html.toLowerCase().match(re);<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_54

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_55

><td class="source">        // no HTML tags present? nothing to do; exit now<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_56

><td class="source">        var tagcount = (tags || []).length;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_57

><td class="source">        if (tagcount == 0)<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_58

><td class="source">            return html;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_59

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_60

><td class="source">        var tagname, tag;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_61

><td class="source">        var ignoredtags = &quot;&lt;p&gt;&lt;img&gt;&lt;br&gt;&lt;li&gt;&lt;hr&gt;&quot;;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_62

><td class="source">        var match;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_63

><td class="source">        var tagpaired = [];<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_64

><td class="source">        var tagremove = [];<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_65

><td class="source">        var needsRemoval = false;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_66

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_67

><td class="source">        // loop through matched tags in forward order<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_68

><td class="source">        for (var ctag = 0; ctag &lt; tagcount; ctag++) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_69

><td class="source">            tagname = tags[ctag].replace(/&lt;\/?(\w+).*/, &quot;$1&quot;);<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_70

><td class="source">            // skip any already paired tags<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_71

><td class="source">            // and skip tags in our ignore list; assume they&#39;re self-closed<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_72

><td class="source">            if (tagpaired[ctag] || ignoredtags.search(&quot;&lt;&quot; + tagname + &quot;&gt;&quot;) &gt; -1)<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_73

><td class="source">                continue;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_74

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_75

><td class="source">            tag = tags[ctag];<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_76

><td class="source">            match = -1;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_77

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_78

><td class="source">            if (!/^&lt;\//.test(tag)) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_79

><td class="source">                // this is an opening tag<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_80

><td class="source">                // search forwards (next tags), look for closing tags<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_81

><td class="source">                for (var ntag = ctag + 1; ntag &lt; tagcount; ntag++) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_82

><td class="source">                    if (!tagpaired[ntag] &amp;&amp; tags[ntag] == &quot;&lt;/&quot; + tagname + &quot;&gt;&quot;) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_83

><td class="source">                        match = ntag;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_84

><td class="source">                        break;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_85

><td class="source">                    }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_86

><td class="source">                }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_87

><td class="source">            }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_88

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_89

><td class="source">            if (match == -1)<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_90

><td class="source">                needsRemoval = tagremove[ctag] = true; // mark for removal<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_91

><td class="source">            else<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_92

><td class="source">                tagpaired[match] = true; // mark paired<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_93

><td class="source">        }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_94

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_95

><td class="source">        if (!needsRemoval)<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_96

><td class="source">            return html;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_97

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_98

><td class="source">        // delete all orphaned tags from the string<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_99

><td class="source"><br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_100

><td class="source">        var ctag = 0;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_101

><td class="source">        html = html.replace(re, function (match) {<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_102

><td class="source">            var res = tagremove[ctag] ? &quot;&quot; : match;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_103

><td class="source">            ctag++;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_104

><td class="source">            return res;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_105

><td class="source">        });<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_106

><td class="source">        return html;<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_107

><td class="source">    }<br></td></tr
><tr
id=sl_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_108

><td class="source">})();<br></td></tr
></table></pre>
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
</td>
</tr></table>

 
<script type="text/javascript">
 var lineNumUnderMouse = -1;
 
 function gutterOver(num) {
 gutterOut();
 var newTR = document.getElementById('gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_' + num);
 if (newTR) {
 newTR.className = 'undermouse';
 }
 lineNumUnderMouse = num;
 }
 function gutterOut() {
 if (lineNumUnderMouse != -1) {
 var oldTR = document.getElementById(
 'gr_svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b_' + lineNumUnderMouse);
 if (oldTR) {
 oldTR.className = '';
 }
 lineNumUnderMouse = -1;
 }
 }
 var numsGenState = {table_base_id: 'nums_table_'};
 var srcGenState = {table_base_id: 'src_table_'};
 var alignerRunning = false;
 var startOver = false;
 function setLineNumberHeights() {
 if (alignerRunning) {
 startOver = true;
 return;
 }
 numsGenState.chunk_id = 0;
 numsGenState.table = document.getElementById('nums_table_0');
 numsGenState.row_num = 0;
 if (!numsGenState.table) {
 return; // Silently exit if no file is present.
 }
 srcGenState.chunk_id = 0;
 srcGenState.table = document.getElementById('src_table_0');
 srcGenState.row_num = 0;
 alignerRunning = true;
 continueToSetLineNumberHeights();
 }
 function rowGenerator(genState) {
 if (genState.row_num < genState.table.rows.length) {
 var currentRow = genState.table.rows[genState.row_num];
 genState.row_num++;
 return currentRow;
 }
 var newTable = document.getElementById(
 genState.table_base_id + (genState.chunk_id + 1));
 if (newTable) {
 genState.chunk_id++;
 genState.row_num = 0;
 genState.table = newTable;
 return genState.table.rows[0];
 }
 return null;
 }
 var MAX_ROWS_PER_PASS = 1000;
 function continueToSetLineNumberHeights() {
 var rowsInThisPass = 0;
 var numRow = 1;
 var srcRow = 1;
 while (numRow && srcRow && rowsInThisPass < MAX_ROWS_PER_PASS) {
 numRow = rowGenerator(numsGenState);
 srcRow = rowGenerator(srcGenState);
 rowsInThisPass++;
 if (numRow && srcRow) {
 if (numRow.offsetHeight != srcRow.offsetHeight) {
 numRow.firstChild.style.height = srcRow.offsetHeight + 'px';
 }
 }
 }
 if (rowsInThisPass >= MAX_ROWS_PER_PASS) {
 setTimeout(continueToSetLineNumberHeights, 10);
 } else {
 alignerRunning = false;
 if (startOver) {
 startOver = false;
 setTimeout(setLineNumberHeights, 500);
 }
 }
 }
 function initLineNumberHeights() {
 // Do 2 complete passes, because there can be races
 // between this code and prettify.
 startOver = true;
 setTimeout(setLineNumberHeights, 250);
 window.onresize = setLineNumberHeights;
 }
 initLineNumberHeights();
</script>

 
 
 <div id="log">
 <div style="text-align:right">
 <a class="ifCollapse" href="#" onclick="_toggleMeta(this); return false">Show details</a>
 <a class="ifExpand" href="#" onclick="_toggleMeta(this); return false">Hide details</a>
 </div>
 <div class="ifExpand">
 
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="changelog">
 <p>Change log</p>
 <div>
 <a href="/p/pagedown/source/detail?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&amp;r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5">8e95798228ee</a>
 by balpha
 on Oct 9, 2014
 &nbsp; <a href="/p/pagedown/source/diff?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5&amp;format=side&amp;path=/Markdown.Sanitizer.js&amp;old_path=/Markdown.Sanitizer.js&amp;old=016a78c093843e203de5364117d34d406a09e8c0">Diff</a>
 </div>
 <pre>Allow creation of ordered lists that start
with numbers other than 1</pre>
 </div>
 
 
 
 
 
 
 <script type="text/javascript">
 var detail_url = '/p/pagedown/source/detail?r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5&spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b';
 var publish_url = '/p/pagedown/source/detail?r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5&spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b#publish';
 // describe the paths of this revision in javascript.
 var changed_paths = [];
 var changed_urls = [];
 
 changed_paths.push('/Markdown.Converter.js');
 changed_urls.push('/p/pagedown/source/browse/Markdown.Converter.js?r\x3d8e95798228eeeaf1222b342b0a8b81bf296bfdb5\x26spec\x3dsvn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b');
 
 
 changed_paths.push('/Markdown.Sanitizer.js');
 changed_urls.push('/p/pagedown/source/browse/Markdown.Sanitizer.js?r\x3d8e95798228eeeaf1222b342b0a8b81bf296bfdb5\x26spec\x3dsvn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b');
 
 var selected_path = '/Markdown.Sanitizer.js';
 
 
 function getCurrentPageIndex() {
 for (var i = 0; i < changed_paths.length; i++) {
 if (selected_path == changed_paths[i]) {
 return i;
 }
 }
 }
 function getNextPage() {
 var i = getCurrentPageIndex();
 if (i < changed_paths.length - 1) {
 return changed_urls[i + 1];
 }
 return null;
 }
 function getPreviousPage() {
 var i = getCurrentPageIndex();
 if (i > 0) {
 return changed_urls[i - 1];
 }
 return null;
 }
 function gotoNextPage() {
 var page = getNextPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoPreviousPage() {
 var page = getPreviousPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoDetailPage() {
 window.location = detail_url;
 }
 function gotoPublishPage() {
 window.location = publish_url;
 }
</script>

 
 <style type="text/css">
 #review_nav {
 border-top: 3px solid white;
 padding-top: 6px;
 margin-top: 1em;
 }
 #review_nav td {
 vertical-align: middle;
 }
 #review_nav select {
 margin: .5em 0;
 }
 </style>
 <div id="review_nav">
 <table><tr><td>Go to:&nbsp;</td><td>
 <select name="files_in_rev" onchange="window.location=this.value">
 
 <option value="/p/pagedown/source/browse/Markdown.Converter.js?r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5&amp;spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b"
 
 >/Markdown.Converter.js</option>
 
 <option value="/p/pagedown/source/browse/Markdown.Sanitizer.js?r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5&amp;spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b"
 selected="selected"
 >/Markdown.Sanitizer.js</option>
 
 </select>
 </td></tr></table>
 
 
 



 
 </div>
 
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="older_bubble">
 <p>Older revisions</p>
 
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="https://ssl.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="https://ssl.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/pagedown/source/detail?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=016a78c093843e203de5364117d34d406a09e8c0">016a78c09384</a>
 by balpha
 on Oct 9, 2014
 &nbsp; <a href="/p/pagedown/source/diff?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=016a78c093843e203de5364117d34d406a09e8c0&amp;format=side&amp;path=/Markdown.Sanitizer.js&amp;old_path=/Markdown.Sanitizer.js&amp;old=e4b33b78d95896d282ea5632fcd83d9cba18b71b">Diff</a>
 <br>
 <pre class="ifOpened">Allow *[]$ in links. Good bye,
EncodeProblemUrlCharacters.</pre>
 </div>
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="https://ssl.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="https://ssl.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/pagedown/source/detail?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=e4b33b78d95896d282ea5632fcd83d9cba18b71b">e4b33b78d958</a>
 by balpha
 on Sep 1, 2011
 &nbsp; <a href="/p/pagedown/source/diff?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=e4b33b78d95896d282ea5632fcd83d9cba18b71b&amp;format=side&amp;path=/Markdown.Sanitizer.js&amp;old_path=/Markdown.Sanitizer.js&amp;old=f2a5240e53a726e3c39b92fab9dd25fd9b7614c4">Diff</a>
 <br>
 <pre class="ifOpened">missed a semicolon (<a title="Sanitizer needs a semicolon at the end" class=closed_ref href="/p/pagedown/issues/detail?id=5"> issue 5 </a>)</pre>
 </div>
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="https://ssl.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="https://ssl.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/pagedown/source/detail?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=f2a5240e53a726e3c39b92fab9dd25fd9b7614c4">f2a5240e53a7</a>
 by balpha
 on Aug 3, 2011
 &nbsp; <a href="/p/pagedown/source/diff?spec=svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b&r=f2a5240e53a726e3c39b92fab9dd25fd9b7614c4&amp;format=side&amp;path=/Markdown.Sanitizer.js&amp;old_path=/Markdown.Sanitizer.js&amp;old=">Diff</a>
 <br>
 <pre class="ifOpened">initial commit</pre>
 </div>
 
 
 <a href="/p/pagedown/source/list?path=/Markdown.Sanitizer.js&r=8e95798228eeeaf1222b342b0a8b81bf296bfdb5">All revisions of this file</a>
 </div>
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="fileinfo_bubble">
 <p>File info</p>
 
 <div>Size: 3907 bytes,
 108 lines</div>
 
 <div><a href="//pagedown.googlecode.com/hg/Markdown.Sanitizer.js">View raw file</a></div>
 </div>
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 </div>
 </div>


</div>

</div>
</div>

<script src="https://ssl.gstatic.com/codesite/ph/1191371308984722110/js/prettify/prettify.js"></script>
<script type="text/javascript">prettyPrint();</script>


<script src="https://ssl.gstatic.com/codesite/ph/1191371308984722110/js/source_file_scripts.js"></script>

 <script type="text/javascript" src="https://ssl.gstatic.com/codesite/ph/1191371308984722110/js/kibbles.js"></script>
 <script type="text/javascript">
 var lastStop = null;
 var initialized = false;
 
 function updateCursor(next, prev) {
 if (prev && prev.element) {
 prev.element.className = 'cursor_stop cursor_hidden';
 }
 if (next && next.element) {
 next.element.className = 'cursor_stop cursor';
 lastStop = next.index;
 }
 }
 
 function pubRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftDestroyed(data) {
 updateCursorForCell(data.cellId, 'nocursor');
 if (initialized) {
 reloadCursors();
 }
 }
 function reloadCursors() {
 kibbles.skipper.reset();
 loadCursors();
 if (lastStop != null) {
 kibbles.skipper.setCurrentStop(lastStop);
 }
 }
 // possibly the simplest way to insert any newly added comments
 // is to update the class of the corresponding cursor row,
 // then refresh the entire list of rows.
 function updateCursorForCell(cellId, className) {
 var cell = document.getElementById(cellId);
 // we have to go two rows back to find the cursor location
 var row = getPreviousElement(cell.parentNode);
 row.className = className;
 }
 // returns the previous element, ignores text nodes.
 function getPreviousElement(e) {
 var element = e.previousSibling;
 if (element.nodeType == 3) {
 element = element.previousSibling;
 }
 if (element && element.tagName) {
 return element;
 }
 }
 function loadCursors() {
 // register our elements with skipper
 var elements = CR_getElements('*', 'cursor_stop');
 var len = elements.length;
 for (var i = 0; i < len; i++) {
 var element = elements[i]; 
 element.className = 'cursor_stop cursor_hidden';
 kibbles.skipper.append(element);
 }
 }
 function toggleComments() {
 CR_toggleCommentDisplay();
 reloadCursors();
 }
 function keysOnLoadHandler() {
 // setup skipper
 kibbles.skipper.addStopListener(
 kibbles.skipper.LISTENER_TYPE.PRE, updateCursor);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_top', 50);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_bottom', 100);
 // Register our keys
 kibbles.skipper.addFwdKey("n");
 kibbles.skipper.addRevKey("p");
 kibbles.keys.addKeyPressListener(
 'u', function() { window.location = detail_url; });
 kibbles.keys.addKeyPressListener(
 'r', function() { window.location = detail_url + '#publish'; });
 
 kibbles.keys.addKeyPressListener('j', gotoNextPage);
 kibbles.keys.addKeyPressListener('k', gotoPreviousPage);
 
 
 }
 </script>
<script src="https://ssl.gstatic.com/codesite/ph/1191371308984722110/js/code_review_scripts.js"></script>
<script type="text/javascript">
 function showPublishInstructions() {
 var element = document.getElementById('review_instr');
 if (element) {
 element.className = 'opened';
 }
 }
 var codereviews;
 function revsOnLoadHandler() {
 // register our source container with the commenting code
 var paths = {'svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b': '/Markdown.Sanitizer.js'}
 codereviews = CR_controller.setup(
 {"projectName": "pagedown", "loggedInUserEmail": "timm.newyyz@gmail.com", "profileUrl": "/u/116895727412923837559/", "assetVersionPath": "https://ssl.gstatic.com/codesite/ph/1191371308984722110", "token": "ABZ6GAcA43V37sPxuGzfUMfsP_ZO-yYC4g:1429209827111", "projectHomeUrl": "/p/pagedown", "relativeBaseUrl": "", "assetHostPath": "https://ssl.gstatic.com/codesite/ph", "domainName": null}, '', 'svn2a8c75ce3fb50b88165efae9d48a8bc87dc4fb2b', paths,
 CR_BrowseIntegrationFactory);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, showPublishInstructions);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_PUB_PLATE, pubRevealed);
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, draftRevealed);
 codereviews.registerActivityListener(CR_ActivityType.DISCARD_DRAFT_COMMENT, draftDestroyed);
 
 
 
 
 
 
 
 var initialized = true;
 reloadCursors();
 }
 window.onload = function() {keysOnLoadHandler(); revsOnLoadHandler();};

</script>
<script type="text/javascript" src="https://ssl.gstatic.com/codesite/ph/1191371308984722110/js/dit_scripts.js"></script>

 
 
 
 <script type="text/javascript" src="https://ssl.gstatic.com/codesite/ph/1191371308984722110/js/ph_core.js"></script>
 
 
 
 
</div> 

<div id="footer" dir="ltr">
 <div class="text">
 <a href="/projecthosting/terms.html">Terms</a> -
 <a href="http://www.google.com/privacy.html">Privacy</a> -
 <a href="/p/support/">Project Hosting Help</a>
 </div>
</div>
 <div class="hostedBy" style="margin-top: -20px;">
 <span style="vertical-align: top;">Powered by <a href="http://code.google.com/projecthosting/">Google Project Hosting</a></span>
 </div>

 
 


 
 </body>
</html>

