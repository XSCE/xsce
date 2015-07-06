<!DOCTYPE html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php require 'incl/service_list.php'; ?>
<link rel="stylesheet" type="text/css" media="all" href="xs-portal.css" />
<HTML>
<HEAD>

<TITLE>Internet-in-a-Box</TITLE>

</HEAD>
<BODY>
<div id="wrapper">
	<div id="xsBanner">
    <?php require 'incl/banner.html'; ?>
  	<div>
	    <h1>Internet-in-a-Box</h1>
      <h3>School Server powered by XSCE</h3>
	  </div>
  </div>
  <div style="clear:both;"></div>

<div id="main">
<br><h2>Interesting Things:</h2>

<div class="xsMenuHeading">
	<img src="/common/images/220px-Wikipedia-logo-v2.svg.png">
	<h2>Wikipedia, Gutenberg Books, Wiktionaries</h2>
</div>

<!-- <h2>More Wikipedias</h2>-->

<?php kiwix_link("wikipedia_en_all_2015-05", "Full English Wikipedia", "The complete English Wikipedia as of May 2015."); ?>

<?php kiwix_link("wiktionary_en_all_2015-05", "English Dictionary", "The English Wiktionary."); ?>

<?php kiwix_link("wikipedia_en_for_schools_opt_2013", "Wikipedia for Schools", "6000 articles selected for school children."); ?>

<!--
<?php kiwix_link("wikipedia_ar_all_2015-05", "Wikipedia in Arabic", "The Wikipedia in Arabic as of May 2015."); ?>

<?php kiwix_link("/wikipedia_fr_all_2015-03", "Wikipedia in French", "The Wikipedia in French as of March 2015."); ?>
-->

<?php hard_link("/rachel", "RACHEL", "Remote Area Community Hotspot for Education and Learning: best free materials from the Internet!"); ?>

<?php kiwix_link("gutenberg_en_all_10_2014", "Project Gutenberg", "Collection of English classic literature."); ?>

<div class="xsMenuHeading">
	<img src="/common/images/ted-talks-logo-150x150.jpg">
	<h2>Conferences on Technology, Entertainment, Design.</h2>
</div>

<?php kiwix_link("ted_en_business_2015-02", "Business"); ?>

<?php kiwix_link("ted_en_design_2015-02", "Design"); ?>

<?php kiwix_link("ted_en_entertainment_2015-02", "Entertainment"); ?>
<BR>

<?php kiwix_link("ted_en_global_issues_2015-02", "Global Issue"); ?>

<?php kiwix_link("ted_en_science_2015-02", "Science"); ?>

<?php kiwix_link("ted_en_technology_2015-02", "Technology"); ?>
<BR><BR>

<div class="xsMenuHeading">
	<img src="/common/images/khan-logo-vertical-transparent.png">
	<h2>Khan Academy</h2>
</div>

<?php kalite_link("KA Lite", "Offline version of Khan Academy."); ?>

<div class="xsMenuHeading">
	<img src="/common/images/osm.jpg">
	<h2>Maps</h2>
</div>

<?php hard_link("/iiab/static/map.html", "OpenStreetMap", "Maps of the entire world from Internet-in-a-Box.","/library/knowledge/modules/openstreetmap/mod_tile64"); ?>

<h2>Collaboration</h2>

<?php hard_link("/owncloud", "ownCloud", "Offline file sharing, calendaring, and collaboration for teachers especially.", "/opt/owncloud/index.php"); ?>

<?php hard_link("/elgg", "Elgg", "Offline social media for students especially.", "/opt/elgg/index.php"); ?>

<?php hard_link("/content", "Access Other Content", "TestPrep PDFs and a growing  list of documents.","/library/content"); ?>

<h2>Tools for Administrators</h2>

<?php xovis_link("XOvis", "Graphs statistics on XO use of Activities."); ?>

<?php hard_link("/munin", "Munin", "Drill down to monitor server performance."); ?>

<?php hard_link("/admin", "Admin Console", "Graphically facilitates control of the server.", "/opt/schoolserver/admin_console"); ?>

<h2>Temporary Passwords</h2>
<ul>
	<li>KA Lite: kalite/kalite</li>
	<li>ownCloud: Admin/changeme</li>
	<li>Elgg: Admin/changeme</li>
	<li>Munin: admin/munindxs</li>
	<li>Admin Console: x<a href="/software" target="_blank">s</a>ce-admin</li>
</ul>


<!--
<h2>Other Content</h2>
<?php hard_link("/content", "Browse Other Content", "This is the place for local downloads."); ?>
-->
<BR><B> Enjoy Exploring & Building Your Library! &nbsp; <I>volunteer@unleashkids.org</I></B>
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
