<!DOCTYPE html>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<?php require 'incl/service_list.php'; ?>
<link rel="stylesheet" type="text/css" media="all" href="xs-portal.css" />
<HTML>
<HEAD>

<TITLE>Byenvini nan Sevè Lekòl La</TITLE>

</HEAD>
<BODY>
<div id="wrapper">	
<h1>Byenvini nan Sevè Lekòl La</h1>
<?php require 'incl/banner.html'; ?>

<div id="main"> 
<br><h2>Dokiman Enteresan Ou Ka Dekouvri Sou Li:</h2>

<?php service_link("pathagar", "Li liv sou Pathagar", "Pathagar se yon sevè ki gen yon koleksyon liv pa anndan ke ou ka li san telechaje yo sou Entenèt."); ?>
<?php hard_link("/content/syans", "Li liv syans", "Isi se liv edikatif sou syans ekri an Kreyol ayisyen pou timoum ki gen 7 an a 9 an."); ?>

<?php // iiab_link("Internet In A Box", 
//                "Internet-in-a-Box is a copy of some of the most important material on the internet, such as the Wikipedia, stored locally where you can reach it easily.",
//                "Chache pou Internet-in-a-Box"); 
?>
<?php service_link("iiab", "Internet-in-a-Box", "Internet-in-a-Box se yon reprodiksyon pifò materyel ki pi enpotan sou Entenèt la, kòm Wikipedia. Yo disponib lokalman, nan Bwat, pou ou ka li yo fasilman."); ?>
<?php service_link("moodle", "Akèy Moodle", "Moodle se yon koleksyon leson ak materyèl edukasyonal oganize pou ede ou aprann anpil bagay enteresan."); ?>
<?php service_link("upload", "Mete fichye yo", "Avek lyèn sa, ou ka mete kèk fichye kòm imaj epi aktivite."); ?>
<?php service_link("activity-server", "Telechaje yon aktivite", "Ou ka ajoute yon aktivite nouvo sou XO ou ak lyèn s."); ?>

<BR>Amize ou byens!
</div><!-- #main -->
</div><!-- #wrapper -->
</BODY>
<script type="text/javascript" src="incl/xs-portal.js"></script>
</HTML>
